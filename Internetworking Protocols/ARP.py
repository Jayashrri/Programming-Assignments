import threading, enum, time, queue, os

def threaded(function):
    def wrapper(*args, **kwargs):
        thread = threading.Thread(target=function, args=args, kwargs=kwargs)
        thread.start()
        return thread
    return wrapper

class MessageType(enum.Enum):
    request = 0
    response = 1

class Node:
    def __init__(self, index, ip_address, mac_address, network):
        self.ip_address = ip_address
        self.mac_address = mac_address
        self.index = index

        self.arp_cache = {}
        self.arp_timeout = 10

        self.message_queue = network[index]
        self.queries = {}
        self.network = network

        self.respond_thread = self.responder()

    def __eq__(self, other):
        return self.index == other.index

    def cache_timeout(self):
        for ip_address, entry in list(self.arp_cache.items()):
            if time.time() > entry['time'] + self.arp_timeout:
                print("Expired Cache Entry: " + ip_address)
                del self.arp_cache[ip_address]
    
    @threaded
    def responder(self):
        while True:
            request = self.message_queue.get()
            if request['type'] == MessageType.request and request['ip_address'] == self.ip_address:
                response = {
                    'sender': self.index, 
                    'type': MessageType.response, 
                    'ip_address': self.ip_address, 
                    'mac_address': self.mac_address
                }
                self.network[request['sender']].put(response)
            elif request['type'] == MessageType.response:
                self.arp_cache[request['ip_address']] = {
                    'mac_address': request['mac_address'],
                    'time': time.time()
                }
                self.queries[request['ip_address']] = 1
    
    @threaded
    def sender(self):
        self.cache_timeout()
        request_ip = input("Request IP Address: ")

        if request_ip in self.arp_cache:
            self.arp_cache[request_ip]['time'] = time.time()
            print("Cached MAC Address Availabe: " + self.arp_cache[request_ip]['mac_address'] + "\n")
        else:
            request = {
                'sender': self.index, 
                'type': MessageType.request, 
                'ip_address': request_ip, 
            }
            self.queries[request_ip] = 0

            for i, node in enumerate(self.network):
                if i != self.index:
                    node.put(request)
            
            timeout = time.time() + 20
            while self.queries[request_ip] == 0 and time.time() <= timeout:
                pass

            if self.queries[request_ip] == 1:
                print("ARP Cache:")
                print(self.arp_cache)
                print("\n")
            else:
                print("Request Timed Out \n")

            del self.queries[request_ip]

    @threaded
    def display_cache(self):
        self.cache_timeout()
        print("ARP Cache:")
        print(self.arp_cache)
        print("\n")

def main():
    nodes = [
        ["172.16.254.1", "00:3e:e1:c4:5d:df"],
        ["193.88.99.46", "00:10:5a:44`:12:b6"],
        ["192.168.25.204", "00:e0:23:45:12:21"],
        ["192.168.1.152", "00:12:3f:b1:17:a5"],
        ["193.168.172.105", "00:1a:80:cd:5a:90"]
    ]

    network = []
    queues = []
    for i, node in enumerate(nodes):
        new_queue = queue.Queue()
        queues.append(new_queue)
        new_node = Node(i, node[0], node[1], queues)
        network.append(new_node)
    
    while True:
        selection = int(input("1. Select Node, 2. Exit: "))
        if selection == 1:
            selected_node = int(input("Selected Node (1-5): "))
            option = int(input("1. Request Address, 2. View ARP Cache: "))
            print("\n")

            if option == 1:
                node_thread = network[selected_node-1].sender()
            elif option == 2:
                node_thread = network[selected_node-1].display_cache()

            node_thread.join()
        elif selection == 2:
            print("Exiting Simulation")
            os._exit(0)

if __name__ == "__main__":
    main()
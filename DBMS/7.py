import mysql.connector

def createDB():
	db = mysql.connector.connect(
	  	host="localhost",
	  	user="root",
		password="pass1234"
	)
	
	cursor = db.cursor()
	cursor.execute("CREATE DATABASE IF NOT EXISTS Railways")

def connectDB():
	db = mysql.connector.connect(
	  	host="localhost",
	  	user="root",
		password="pass1234",
		database="Railways"
	)
	
	cursor = db.cursor()
	cursor.execute("CREATE TABLE IF NOT EXISTS Reservation ( seat INT, name VARCHAR(255), source VARCHAR(255), destination VARCHAR(255), PRIMARY KEY (seat) )")
	
	return db

def insert(db, seat, name, source, destination):
	cursor = db.cursor()
	sql = "INSERT INTO Reservation VALUES (%s, %s, %s, %s)"
	values = (seat, name, source, destination)
	
	cursor.execute(sql, values)
	db.commit()
	
def find(db, name):
	cursor = db.cursor()
	sql = "SELECT * FROM Reservation WHERE name=%s"
	value = (name, )
	
	cursor.execute(sql, value)
	results = cursor.fetchall()
	
	for result in results:
		print(result)

def update(db, seat, destination):
	cursor = db.cursor()
	sql = "UPDATE Reservation SET destination=%s WHERE seat=%s"
	values = (destination, seat)
	
	cursor.execute(sql, values)
	db.commit()
	
def delete(db, seat):
	cursor = db.cursor()
	sql = "DELETE FROM Reservation WHERE seat=%s"
	value = (seat, )
	
	cursor.execute(sql, value)
	db.commit()

def main(db):
	select = input("1. Insert, 2. Find, 3. Update, 4. Delete : ")
	
	if select == "1":
		seat = input("Seat: ")
		name = input("Name: ")
		source = input("Source: ")
		destination = input("Destination: ")
		
		insert(db, seat, name, source, destination)
	elif select == "2":
		name = input("Name: ")
		
		find(db, name)
	elif select == "3":
		seat = input("Seat: ")
		destination = input("Destination: ")
		
		update(db, seat, destination)
	elif select == "4":
		seat = input("Seat: ")
		
		delete(db, seat)

if __name__ == "__main__":
	createDB()
	db = connectDB()
	
	while(1):
		main(db)
		select = input("1. Continue, 2. Exit : ")
		
		if select == "2":
			break;

		

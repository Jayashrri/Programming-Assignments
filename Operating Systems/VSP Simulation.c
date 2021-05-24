#include<stdio.h>
#include <stdlib.h>

struct Process {
    int id;
    int size;
    int arrival;
    int lifetime;

    int startAddr;
    int startTime;

    int valid;

    struct Process *next;
};

struct Node {
    struct Process *process;
    int startAddr;
    int endAddr;
    int size;
    struct Node *next;
};

void printAverageTurnaround(struct Process *processes) {
    struct Process *p = processes;
    float turnaround = 0;
    int processCount = 0;

    while(p != NULL) {
        if(p->startAddr != -1) {
            turnaround += p->startTime - p->arrival + p->lifetime;
            processCount++;
        }
        p = p->next;
    }

    printf("Average Turnaround Time: %.2f\n", turnaround/processCount);
}

void printMemoryMap(struct Node *memStart) {
    struct Node *memBlock = memStart;
    printf("Memory Map:\n");

    while(memBlock != NULL) {
        printf("%d - %d: ", memBlock->startAddr, memBlock->endAddr);
        if(memBlock->process == NULL) {
            printf("Hole\n");
        } else {
            printf("Process %d\n", memBlock->process->id);
        }
        memBlock = memBlock->next;
    }
} 

int removeInactive(struct Node *memStart, int time, int usedBlocks, int *printFlag) {
    struct Node *memBlock = memStart;
    int endTime;
    int requireMemMap = 0;

    while(memBlock != NULL) {
        if(memBlock->process != NULL) {
            endTime = memBlock->process->startTime + memBlock->process->lifetime;
            if(endTime == time) {
                if(*printFlag == 0) {
                    printf("\nt = %d:\n", time);
                    *printFlag = 1;
                }
                printf("Process %d completes\n", memBlock->process->id);
                requireMemMap = 1;

                memBlock->process = NULL;
                usedBlocks--;
            }
        }
        memBlock = memBlock->next;
    }

    memBlock = memStart;
    while(memBlock->next != NULL) {
        if(memBlock->process == NULL && memBlock->next->process == NULL) {
            struct Node *removed = memBlock->next;
            memBlock->size += removed->size;
            memBlock->endAddr = removed->endAddr;
            memBlock->next = removed->next;

            free(removed);
        } else {
            memBlock = memBlock->next;
        }
    }

    if(requireMemMap == 1) {
        printMemoryMap(memStart);
    }

    return usedBlocks;
}

void firstFit(struct Node *memStart, struct Process *processes, int processCount) {
    struct Node *memBlock;
    struct Process *current = processes;
    int time = 0;
    int usedBlocks = 0;
    int extra;
    int i = 0;
    int printFlag = 0;
    
    while(i < processCount) {
        if(time == current->arrival) {
            if(printFlag == 0) {
                printf("\nt = %d:\n", time);
                printFlag = 1;
            }

            printf("Process %d arrives\n", current->id);
        }
        if(current->valid == 0) {
            current = current->next;
        } else if(current->startAddr == -1 && current->arrival <= time) {
            memBlock = memStart;
            while(memBlock != NULL) {
                if(memBlock->process == NULL && memBlock->size >= current->size) {                
                    current->startAddr = memBlock->startAddr;
                    current->startTime = time;

                    extra = memBlock->size - current->size;
                    if(extra != 0) {
                        struct Node *newBlock = (struct Node *)malloc(sizeof(struct Node));
                        newBlock->size = extra;
                        newBlock->startAddr = memBlock->startAddr + current->size;
                        newBlock->endAddr = memBlock->endAddr;
                        newBlock->next = memBlock->next;
                        newBlock->process = NULL;

                        memBlock->size = current->size;
                        memBlock->endAddr = newBlock->startAddr - 1;
                        memBlock->process = current;
                        memBlock->next = newBlock;
                    } else {
                        memBlock->process = current;
                    }

                    if(printFlag == 0) {
                        printf("\nt = %d:\n", time);
                        printFlag = 1;
                    }

                    printf("Process %d is moved into memory\n", current->id);
                    printMemoryMap(memStart);

                    usedBlocks++;
                    i++;
                    break;
                } else {
                    memBlock = memBlock->next;
                }
            }

            current = current->next;
        } else if(current->arrival > time) {
            time++;
            printFlag = 0;
            usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
            continue;
        } else if(current->startAddr != -1) {
            current = current->next;
        }

        if(current == NULL) {
            current = processes;
            time++;
            printFlag = 0;
            usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
        }
    }

    while(memStart->next != NULL) {
        time++;
        printFlag = 0;
        usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
    }

    printAverageTurnaround(processes);
}

void bestFit(struct Node *memStart, struct Process *processes, int processCount) {
    struct Node *memBlock;
    struct Process *current = processes;
    int time = 0;
    int usedBlocks = 0;
    int extra;
    int bestStart;
    int bestSize;
    int i = 0;
    int printFlag = 0;

    while(i < processCount) {
        if(time == current->arrival) {
            if(printFlag == 0) {
                printf("\nt = %d:\n", time);
                printFlag = 1;
            }

            printf("Process %d arrives\n", current->id);
        }
        if(current->valid == 0) {
            current = current->next;
            if(current == NULL) {
                current = processes;
                time++;
            }
            continue;
        }

        usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
        if(current->startAddr == -1 && current->arrival <= time) {
            memBlock = memStart;
            bestStart = -1;
            bestSize = -1;

            while(memBlock != NULL) {
                if(memBlock->process == NULL && memBlock->size >= current->size) {
                    if(bestStart == -1) {
                        bestStart = memBlock->startAddr;
                        bestSize = memBlock->size;
                    } else if(memBlock->size < bestSize) {
                        bestStart = memBlock->startAddr;
                        bestSize = memBlock->size;
                    }
                }
                memBlock = memBlock->next;
            }

            if(bestStart != -1) {
                memBlock = memStart;
                while(memBlock->startAddr != bestStart) {
                    memBlock = memBlock->next;
                }

                current->startAddr = memBlock->startAddr;
                current->startTime = time;

                extra = memBlock->size - current->size;
                if(extra != 0) {
                    struct Node *newBlock = (struct Node *)malloc(sizeof(struct Node));
                    newBlock->size = extra;
                    newBlock->startAddr = memBlock->startAddr + current->size;
                    newBlock->endAddr = memBlock->endAddr;
                    newBlock->next = memBlock->next;
                    newBlock->process = NULL;

                    memBlock->size = current->size;
                    memBlock->endAddr = newBlock->startAddr - 1;
                    memBlock->process = current;
                    memBlock->next = newBlock;
                } else {
                    memBlock->process = current;
                }

                if(printFlag == 0) {
                    printf("\nt = %d:\n", time);
                    printFlag = 1;
                }

                printf("Process %d is moved into memory\n", current->id);
                printMemoryMap(memStart);

                usedBlocks++;
                i++;
            }

            current = current->next;
        } else if(current->arrival > time) {
            time++;
            printFlag = 0;
            continue;
        } else if(current->startAddr != -1) {
            current = current->next;
        }

        if(current == NULL){
            current = processes;
            time++;
            printFlag = 0;
        }
    }

    while(memStart->next != NULL) {
        time++;
        printFlag = 0;
        usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
    }

    printAverageTurnaround(processes);
}

void worstFit(struct Node *memStart, struct Process *processes, int processCount) {
    struct Node *memBlock;
    struct Process *current = processes;
    int time = 0;
    int usedBlocks = 0;
    int extra;
    int worstStart;
    int worstSize;
    int i = 0;
    int printFlag = 0;

    while(i < processCount) {
        if(time == current->arrival) {
            if(printFlag == 0) {
                printf("\nt = %d:\n", time);
                printFlag = 1;
            }

            printf("Process %d arrives\n", current->id);
        }
        if(current->valid == 0) {
            current = current->next;
            if(current == NULL) {
                current = processes;
                time++;
            }
            continue;
        }

        usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
        if(current->startAddr == -1 && current->arrival <= time) {
            memBlock = memStart;
            worstStart = -1;
            worstSize = -1;

            while(memBlock != NULL) {
                if(memBlock->process == NULL && memBlock->size >= current->size) {
                    if(worstStart == -1) {
                        worstStart = memBlock->startAddr;
                        worstSize = memBlock->size;
                    } else if(memBlock->size > worstSize) {
                        worstStart = memBlock->startAddr;
                        worstSize = memBlock->size;
                    }
                }
                memBlock = memBlock->next;
            }

            if(worstStart != -1) {
                memBlock = memStart;
                while(memBlock->startAddr != worstStart) {
                    memBlock = memBlock->next;
                }

                current->startAddr = memBlock->startAddr;
                current->startTime = time;

                extra = memBlock->size - current->size;
                if(extra != 0) {
                    struct Node *newBlock = (struct Node *)malloc(sizeof(struct Node));
                    newBlock->size = extra;
                    newBlock->startAddr = memBlock->startAddr + current->size;
                    newBlock->endAddr = memBlock->endAddr;
                    newBlock->next = memBlock->next;
                    newBlock->process = NULL;

                    memBlock->size = current->size;
                    memBlock->endAddr = newBlock->startAddr - 1;
                    memBlock->process = current;
                    memBlock->next = newBlock;
                } else {
                    memBlock->process = current;
                }

                if(printFlag == 0) {
                    printf("\nt = %d:\n", time);
                    printFlag = 1;
                }

                printf("Process %d is moved into memory\n", current->id);
                printMemoryMap(memStart);


                usedBlocks++;
                i++;
            }

            current = current->next;
        } else if(current->arrival > time) {
            time++;
            printFlag = 0;
            continue;
        } else if(current->startAddr != -1) {
            current = current->next;
        }

        if(current == NULL){
            current = processes;
            time++;
            printFlag = 0;
        }
    }

    while(memStart->next != NULL) {
        time++;
        printFlag = 0;
        usedBlocks = removeInactive(memStart, time, usedBlocks, &printFlag);
    }

    printAverageTurnaround(processes);
}

struct Node * initMem(int memSize) {
    struct Node *memStart = (struct Node *)malloc(sizeof(struct Node));
    memStart->process = NULL;
    memStart->startAddr = 0;
    memStart->endAddr = memSize - 1;
    memStart->size = memSize;
    return memStart;
}

int main() {
    int memSize, fit;
    printf("Memory Size: ");
    scanf("%d", &memSize);
    printf("Memory Management Policy (1 - First Fit, 2 - Best Fit, 3 - Worst Fit): ");
    scanf("%d", &fit);

    struct Node *memStart = initMem(memSize);

    struct Process *processes = NULL;
    struct Process *temp = NULL;

    int processCount;
    printf("Number of Processes: ");
    scanf("%d", &processCount);

    int id, arrival, lifetime, size;
    int invalid = 0;
    printf("\nProcess Details (in order of arrival)\n");
    for(int i=0; i<processCount; i++) {
        printf("Process %d - ID, Arrival, Lifetime, Size: ", i+1);
        struct Process *P = (struct Process *)malloc(sizeof(struct Process));
        scanf("%d", &id);
        scanf("%d", &arrival);
        scanf("%d", &lifetime);
        scanf("%d", &size);

        P->id = id;
        P->arrival = arrival;
        P->lifetime = lifetime;
        P->size = size;
        P->next = NULL;
        P->startAddr = -1;
        P->startTime = -1;

        if(P->size > memSize) {
            P->valid = 0;
            invalid++;
        } else P->valid = 1;

        if(processes == NULL) {
            processes = P;
            temp = P;
        } else {
            temp->next = P;
            temp = P;
        }
    }

    switch(fit) {
        case 1:
            firstFit(memStart, processes, processCount - invalid);
            break;
        case 2:
            bestFit(memStart, processes, processCount - invalid);
            break;
        case 3:
            worstFit(memStart, processes, processCount - invalid);
            break;
    }

    return 0;
}
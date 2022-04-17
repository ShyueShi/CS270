/*
* Author: Shyue Shi Leong
* Date:  11/24/2019
* Description: Program to simulate office hours.
*
* Explaination for why round robin is better than FIFO
*    The round robin algorithm is better than the FIFO implementation is due to several reasons. The
* first reason is that it improves the average response time of the system. The round robin algorithm 
* is same as the FIFO algorthim, but it is only allowed to be carried out for a fixed amount of time.
* The round robin algorithm also allows all students on the day a chance to meet with the professor.
*
* Explaination for the cost and tradeoff of FIFO and round robin algorithm
*    The cost of the FIFO implementation is that a long running process will delay all students behind
* it. For example, if the professor have only 20 minutes for a particular day, but the first student in
* the list is meeting with the professor for 18 minutes. The rest of the students will be waiting for a
* whole 18 minutes before they get to see the professor and some students may not have the chance
* to meet with the professor. For the round robin algortihm, the cost is the quantum used for the 
* algorithm. If the quantum selected is too small, then it is not very efficient due to the need to
* change to the next student so quickly. If the quantum is too big, then it would just behave like the 
* FIFO alogrithm. 
*/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "stu_list.h"

/* globals */

// total number of students
int num_students;
// struct containing information about the professor
professor prof;
// dynamically allocated array of all of the students
student * all_students;
// 0 = true, nonzero = false
int is_fifo;
int rr_quantum;
// counters for final stats
int tot_waiting = 0;
int tot_done = 0;
int tot_visit_min = 0;

/* function prototypes */

/* Functions you need to write */
void read_data(FILE * infile);
stu_list * init_day(days_t today);
void cleanup_list(stu_list * today);
void simulate(stu_list * today, days_t day);
int is_all_done();


/* Given print and helper functions */
void print_final_stats();
void print_init_stats();
void print_state();
void print_daily_stats(days_t d, int visits, int v_mins, int waiting, int wait_mins);
void correct_usage_message();
char * day_to_string(days_t d);
char * type_to_string(visit_t t);



int main(int argc, char** argv){
  /* variable declarations for main */
  FILE * infile = NULL;
  stu_list * daily = NULL;
  days_t day;
  /* parse command-line arguments
   *   - argv[1] should be -f (for FIFO) or -r (for round-robin)
   *     - if round-robin, argv[2] will be the quantum
   *   - argv[argc - 1] is the file that contains the configuration of the simulation
   *  Your program should handle the following error cases gracefully:
   *   - file not opened properly: "Unable to open file."
   *   - incorrect number of arguments: "Incorrect number of arguments."
   *   - incorrect flag for algorithm: "Incorrect flag for algorithm."
   *   - missing quantum for RR: "Missing quantum for RR."
   *  For each of the error cases, print the message above and the correct_usage_message.
   */
  
  if(argc== 3 || argc == 4){
    char* check1 = strchr(argv[1], 'f');
    char* check2 = strchr(argv[1], 'r');
     if(check1 != NULL){
 	if(argc != 3){
	   printf("Incorrect number of arguments.\n");
	   correct_usage_message();
	   return 0;
        }
        else{
	   is_fifo = 0;
	   infile = fopen(argv[2], "r"); 
        }
     }
     else if(check2 != NULL){
	rr_quantum = strtol(argv[2], NULL, 10);
        if(rr_quantum == 0){
           printf("Missing quantum for RR.\n");
           correct_usage_message();
           return 0;
        }
	else if(rr_quantum < 0){
	   printf("Quantum cannot be negative.\n");
	   correct_usage_message();
           return 0;
        }

 	if(argc != 4){
	   printf("Incorrect number of arguments.\n");
	   correct_usage_message();
	   return 0;
        }
        else{
	   is_fifo = 1;
	   infile = fopen(argv[3], "r");
        }
     }
     else{
	printf("Incorrect flag for algorithm.\n");
        correct_usage_message();
        return 0;
     }
  }
  else{
     printf("Incorrect number of arguments.\n");
     correct_usage_message();
     return 0;
  }

  if(infile == NULL){
     printf("Unable to open file.\n");
     correct_usage_message();
     return 0;
  }
  // read in the data
  read_data(infile);
  fclose(infile);
  
  // print initial stats
  print_init_stats();

  day = MONDAY;
  
  // while all students are not done:
  while(is_all_done() != 0){
    //   foreach day
    //     - init day: for all of the students, add those who can attend today
    daily = init_day(day);
    //     - simulate day, this will include printing of daily stats
    simulate(daily, day);

    // free the nodes of the list and the list itself
    cleanup_list(daily);
    free(daily);
    daily = NULL;
    day = (day + 1) % 5;
   }

  // print final stats
  print_final_stats();
  // free all data structures
  
  return 0;
}

/*******************************************************************************
 * Functions you need to write.  You can add more helpers as desired.          *
 ******************************************************************************/

/*
* Read in the data from the file infile.  Assume that infile has been opened
* for reading and is not NULL.
*/
void read_data(FILE * infile){
  // TODO - see project description and sample input file for the structure of the data
  char* fgets_rtn = NULL;
  char* check1;
  char* check2;
  int lineLen = 100;
  int i;
  char buffer[lineLen];
  fgets_rtn = fgets(buffer,lineLen, infile);
  if('\n' == buffer[strlen(buffer)-1]){
     buffer[strlen(buffer)-1] = '\0';
  }
  prof.name = strdup(buffer);

  
  for(i = 0; i < 5; i++){
     fgets_rtn = fgets(buffer, lineLen, infile);
     if(fgets_rtn != NULL){
        if('\n' == buffer[strlen(buffer)-1]){
           buffer[strlen(buffer)-1] = '\0';
        }
     }
     prof.schedule[i] = strtol(buffer, NULL, 10);
  }
  
  
  fgets_rtn = fgets(buffer,lineLen, infile);
  if('\n' == buffer[strlen(buffer)-1]){
     buffer[strlen(buffer)-1] = '\0';
  }
  num_students = strtol(buffer, NULL, 10);
  
  all_students = (student*)malloc(sizeof(student) * num_students);
  
  for(i = 0; i < num_students; i++){
     fgets_rtn = fgets(buffer, lineLen, infile);
     if('\n' == buffer[strlen(buffer)-1]){
        buffer[strlen(buffer)-1] = '\0';
     }
     all_students[i].name = strdup(buffer);
     all_students[i].id = i;
     
     fgets_rtn = fgets(buffer, lineLen, infile);
     if('\n' == buffer[strlen(buffer)-1]){
        buffer[strlen(buffer)-1] = '\0';
     }
     check1 = strchr(buffer, 'Q');
     check2 = strchr(buffer, 'A');
     if(check1 !=NULL){
	all_students[i].visit_type = QUESTION;
     }
     else if(check2 !=NULL){
	all_students[i].visit_type = ADVISING;
     }
     else{
	all_students[i].visit_type = DEMO;
     }
     
     fgets_rtn = fgets(buffer, lineLen, infile);
     if('\n' == buffer[strlen(buffer)-1]){
        buffer[strlen(buffer)-1] = '\0';
     }
     all_students[i].visit = strtol(buffer, NULL, 10);
     
     fgets_rtn = fgets(buffer, lineLen, infile);
     if('\n' == buffer[strlen(buffer)-1]){
        buffer[strlen(buffer)-1] = '\0';
     }
    
     check1 = strchr(buffer, 'M');
     if(check1 != NULL){
	all_students[i].available[0] = 1;
     }
     else{
	all_students[i].available[0] = 0;
     }

     check1 = strchr(buffer, 'T');
     if(check1 != NULL){
	all_students[i].available[1] = 1;
     }
     else{
	all_students[i].available[1] = 0;
     }

     check1 = strchr(buffer, 'W');
     if(check1 != NULL){
	all_students[i].available[2] = 1;
     }
     else{
	all_students[i].available[2] = 0;
     }

     check1 = strchr(buffer, 'R');
     if(check1 != NULL){
	all_students[i].available[3] = 1;
     }
     else{
	all_students[i].available[3] = 0;
     }

     check1 = strchr(buffer, 'F');
     if(check1 != NULL){
	all_students[i].available[4] = 1;
     }
     else{
	all_students[i].available[4] = 0;
	}
     all_students[i].curr_state = INIT;
     }
}




/*
* Create a new list and add all of the students who will be waiting that day
* to the list according to the mode.
*   mode = 0 is FIFO
*   mode = nonzero is SVF
*/
stu_list * init_day(days_t today){
  // TODO
  stu_list * a_list = NULL;
  a_list = (stu_list*)malloc(sizeof(stu_list));
  init_list(a_list);
  int i;
  for(i = 0; i < num_students; i++){
     if(all_students[i].available[today] == 1 && all_students[i].curr_state!= DONE){
       add(a_list, &all_students[i]);
     }
  }

  return a_list;
}

/*
 * Free the nodes of the list so the list itself is ready to be freed.
 */
void cleanup_list(stu_list * a_list){
  // TODO
  int i;
  for(i = 0; i < a_list->size; i++){
     pop(a_list);
  }
}


/*
* Return 0 when all of the students have visited the professor.
*/
int is_all_done(){
  // TODO
  int i;
  for(i = 0; i < num_students; i++){
      if(all_students[i].curr_state != DONE){
	  return 1;
      }
  }
  return 0;
}

/*
* Simulate the day using FIFO
*/
void simulate(stu_list * today, days_t day){
  int visits = 0;
  int visit_minutes = 0;
  int waiting = 0;
  int waiting_student_minutes = 0;
  // TODO
  int i;
  int temp;
  int temp2;
  int count=0;
  stu_node* cur_pos;
  if(is_fifo == 0){
    cur_pos = today->head->next;
    for(i = 0; i < today->size; i++){
        prof.curr_student = cur_pos->data;	
        if(cur_pos->data->curr_state !=DONE){
           if(visit_minutes < prof.schedule[day]){
	     printf("Professor %s is %s %s\n",prof.name, type_to_string(cur_pos->data->visit_type), cur_pos->data->name);
              temp = cur_pos->data->visit + visit_minutes;
	      cur_pos->data->curr_state = VISITING;
	      if(temp <= prof.schedule[day]){
	         visit_minutes = visit_minutes + cur_pos->data->visit;
	         visits = visits + 1;
	         cur_pos->data->curr_state = DONE;
              }
	      else{
	         visits = visits + 1;
	         temp2 = prof.schedule[day] - visit_minutes;
	         cur_pos->data->visit = cur_pos->data->visit - temp2;
                 visit_minutes = prof.schedule[day];
		 cur_pos->data->curr_state = WAITING;
	      }
	      waiting_student_minutes = waiting_student_minutes + visit_minutes;
           }
           else{
	     waiting = waiting + 1;
	     waiting_student_minutes = waiting_student_minutes + visit_minutes;
           }
        }
        cur_pos = cur_pos->next;
     }
    waiting_student_minutes = waiting_student_minutes - visit_minutes;
  }
  else{
    cur_pos = today->head->next;
    temp2 = today->size;
    while(visit_minutes < prof.schedule[day]){
      if(today->size == 0){
	break;
      }
      prof.curr_student = cur_pos->data;
      
      if(cur_pos->data->curr_state!= DONE){
	printf("Professor %s is %s %s\n",prof.name, type_to_string(cur_pos->data->visit_type), cur_pos->data->name);
        cur_pos->data->curr_state = VISITING;
	visits = visits + 1;
	
	if(visit_minutes + rr_quantum <= prof.schedule[day]){
	  if(cur_pos->data->visit <= rr_quantum){
	    count = count + 1;
	    temp2 = temp2 - 1;
	    cur_pos->data->curr_state = DONE;
	    visit_minutes = visit_minutes + cur_pos->data->visit;
	    waiting_student_minutes = waiting_student_minutes + (cur_pos->data->visit * temp2);
	  }
	  else{
	    visit_minutes = visit_minutes + rr_quantum;
	    cur_pos->data->visit = cur_pos->data->visit - rr_quantum;
	    waiting_student_minutes = waiting_student_minutes + (rr_quantum * (temp2-1));
	    cur_pos->data->curr_state = WAITING;
	  }
	}
	else{
	  temp = prof.schedule[day] - visit_minutes;
	  if(cur_pos->data->visit <= temp){
	    count = count + 1;
	    temp2 = temp2 - 1;
	    cur_pos->data->curr_state = DONE;
	    visit_minutes = visit_minutes + cur_pos->data->visit;
	    waiting_student_minutes = waiting_student_minutes + (cur_pos->data->visit * temp2);
	  }
	  else{
	    visit_minutes = visit_minutes + temp;
	    cur_pos->data->visit = cur_pos->data->visit - temp;
	    waiting_student_minutes = waiting_student_minutes + (temp * (temp2-1));
	    cur_pos->data->curr_state = WAITING;
	  }
	  //consider student visit < quantum
	  
	  
	}
	
      }

      if(count == today->size){
	break;
      }
      
      if(cur_pos->next == today->tail){
	cur_pos = today->head->next;
      }
      else{
	cur_pos = cur_pos->next;
      }
    }
    if(count == today->size){
      waiting = 0;
    }
    else{
       waiting = today->size - count - 1;
    }
   
  }
 
  print_daily_stats(day, visits, visit_minutes, waiting, waiting_student_minutes);
}

/*******************************************************************************
 * Helpers and print functions - DO NOT CHANGE                                 *
 ******************************************************************************/

/*
 * Prints the stats for the end of a day of simulation
 */
void print_daily_stats(days_t d, int visits, int v_mins, int waiting, int wait_mins){
  // print the statistics
  printf("Stats for %s:\n", day_to_string(d));
  printf("\t Visits: %10d   |   Visit Minutes: %10d\n", visits, v_mins);
  printf("\t Waiting: %9d   |   Waiting Minutes: %8d\n", waiting, wait_mins);
  printf("-----------------------------------------------------------\n");
  tot_waiting += wait_mins;
  tot_visit_min += v_mins;
}

char * day_to_string(days_t d){
  switch(d){
    case MONDAY:
      return strdup("Monday");
    case TUESDAY:
      return strdup("Tuesday");
    case WEDNESDAY:
      return strdup("Wednesday");
    case THURSDAY:
      return strdup("Thursday");
    case FRIDAY:
      return strdup("Friday");
    default:
      return strdup("Uh oh!");
  }
}

char * type_to_string(visit_t t){
  switch(t){
    case QUESTION:
      return strdup("answering a question from");
    case ADVISING:
      return strdup("advising");
    case DEMO:
      return strdup("viewing a demo from");
    default:
      return strdup("Uh oh!");
  }
}

/*
* Print the state of the simulation - used for debugging
*/
void print_state(){
  int i;
  for(i = 0; i < num_students; i++){
    printf("\t%d %s %d %d ", all_students[i].id, all_students[i].name, all_students[i].visit, all_students[i].waiting);
    switch(all_students[i].visit_type){
      case QUESTION:
        printf("Q ");
        break;
      case ADVISING:
        printf("A ");
        break;
      case DEMO:
        printf("D ");
        break;
      default:
        printf("uh oh! ");
        break;
    }
    switch(all_students[i].curr_state){
      case INIT:
        printf("-- init\n");
        break;
      case WAITING:
        printf("-- waiting\n");
        break;
      case VISITING:
        printf("-- visiting\n");
        break;
      case DONE:
        printf("-- done\n");
        break;
      default:
        printf("-- uh oh!\n");
        break;
    }
  }
}

/*
* Print the initial statistics about the simulation
*/
void print_init_stats(){
  printf("Simulating Office Hours for Professor %s\n", prof.name);
  printf("-----------------------------------------------------------\n");
  if(is_fifo == 0){
    printf("Algorithm: FIFO\n");
  }
  else{
    printf("Algorithm: RR Q = %d\n", rr_quantum);
  }
  printf("Schedule:\n");
  printf("%10s %10s %10s %10s %10s\n", "M", "T", "W", "R", "F");
  printf("-----------------------------------------------------------\n");
  printf("%10d %10d %10d %10d %10d\n", prof.schedule[MONDAY],
                                       prof.schedule[TUESDAY],
                                       prof.schedule[WEDNESDAY],
                                       prof.schedule[THURSDAY],
                                       prof.schedule[FRIDAY]);
  printf("===========================================================\n");
  printf("Initial list of students:\n");
  print_state();
  printf("===========================================================\n");

}
/*
* Print the final statistics about the simulation
*/
void print_final_stats(){
  printf("-----------------------------------------------------------\n");
  printf("Professor %s met with %d students for %d minutes\nwith a total waiting time of %d.\n",
              prof.name, num_students, tot_visit_min, tot_waiting);
  printf("===========================================================\n");

}

/*
 * Prints the correct usage message.
 */
void correct_usage_message(){
  //printf("Please use -f to indicate FIFO or -r for round-robin followed by the time quantum, and provide the name of the file for configuring the simulation.\n");
  printf("Please use -f to indicate FIFO or -r for round robin and an appropriate time quantum, and provide the name of the file for configuring the simulation.\n");
}

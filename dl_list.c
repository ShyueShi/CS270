/*
 * Author: Shyue Shi Leong
 * Date: 11/19/2019
 *
 * Description: A doubly-linked list of integers using sentinel nodes.
 */

#include "dl_list.h"

/*
 * Creates a node with value val, next = NULL and prev =NULL.
 */
node* create(int val){
  node* new_node = (node*)malloc(sizeof(node*));
  if(new_node == NULL){
    printf("Something is wrong");
    return NULL;
  }
  new_node->value = val;
  new_node->prev = NULL;
  new_node->next = NULL;
  return new_node;
}

/*
 * Initialize an empty list
 * Allocate space for sentinel nodes and set their links.
 * Initialize size to 0.
 */
void init_list(dl_list* the_list){
  the_list->head = create(0);
  the_list->tail = create(0);
  the_list->head->next = the_list->tail;
  the_list->tail->prev = the_list->head;
  the_list->size = 0;
}

/*
 * Append 
 * Creates a new node with value val and adds it to the end of the list.
 */
void append(dl_list* the_list, int val){
  node* new_node = create(val);
  if(new_node == NULL){
    printf("Something is wrong");
  }
  new_node->next = the_list->tail;
  new_node->prev = the_list->tail->prev;
  the_list->tail->prev->next = new_node;
  the_list->tail->prev = new_node;
  the_list->size++;
}

/*
 * Prepend
 * Creates a new node with value val and adds it to the beginning of the list.
 */
void prepend(dl_list* the_list, int val){
  node* new_node = create(val);
  if(new_node == NULL){
    printf("Something is wrong");
  }
  new_node->next = the_list->head->next;
  new_node->prev = the_list->head;
  the_list->head->next->prev = new_node;
  the_list->head->next = new_node;
  the_list->size++;
}

/*
 * Insert at location i. If i >= size, append to end of list.
 * If i < 0, prepend to beginning.
 */
void insert_at(dl_list* the_list, int val, int i){
  int j;

  node* cur_pos = the_list->head->next;
  node* new_node = create(val);

  if(i >= the_list->size){
    append(the_list, val);
  }
  else if(i <= 0){
    prepend(the_list, val);
  }
  else{
    for(j = 1; j < i; j++){
      cur_pos = cur_pos->next;
    }
    new_node->next = cur_pos->next;
    new_node->prev = cur_pos;
    cur_pos->next->prev = new_node;
    cur_pos->next = new_node;
    the_list->size++;
  }
}

/*
 * Index of - returns the index of val in the list. If not found, -1 is returned.
 */
int index_of(dl_list* the_list, int val){
  node* cur_pos = the_list->head->next;
  int j;
  
  for(j = 0; j < the_list->size; j++){
    if(cur_pos->value == val){
      return j;
    }
    cur_pos = cur_pos->next;
  }
  return -1;
}

/*
 * Delete value
 * Deletes the value from the list. If not found, list unchanged.
 * Returns 0 on success, -1 on not found.
 */
int delete_from_list(dl_list* the_list, int val){
  int j;

  node* cur_pos = the_list->head->next;

  while(cur_pos != the_list->tail){
    j = cur_pos->value;
    if(j == val){
       cur_pos->next->prev = cur_pos->prev;
       cur_pos->prev->next = cur_pos->next;
       free(cur_pos);
       cur_pos = NULL;
       the_list->size--;
       return 0;
    }
   
    cur_pos = cur_pos->next;
  }
  return -1;
}

/*
 * Delete element at location i. If i >= size or i < 0, do nothing. 
 */
void delete_at(dl_list* the_list, int i){
  int j;
  node* cur_pos = the_list->head->next;

  if(i >= the_list->size || i < 0){
    return;
  }
  else{
    for(j = 0; j < i ; j++){
      cur_pos = cur_pos->next;
    }
    cur_pos->prev->next = cur_pos->next;
    cur_pos->next->prev = cur_pos->prev;
    free(cur_pos);
    cur_pos = NULL;
    the_list->size--;
  }
}

/*
 * Set the value of the element at the location idx to the value val.
 */
int set(dl_list* the_list, int idx, int val){
  int j;

  node* cur_pos = the_list->head->next;

  if(idx >= the_list->size || idx < 0){
    return -1;
  }
  
  for(j = 0; j < idx ; j++){
    cur_pos = cur_pos->next;
  }
  cur_pos->value = val;
  return 0;
  
}

/*
 * Print
 */
void print_list(dl_list* the_list){
  //start at the beginning
  node* cur_pos = the_list->head->next;

  printf("{");
  //while we are not at the end...
  while(cur_pos != the_list->tail){
    if(cur_pos->next != the_list->tail){
      //not the last value
      printf("%d, ",cur_pos->value);
    }
    else{
      //last value
      printf("%d",cur_pos->value);
    }
    //move on to the next element
    cur_pos = cur_pos->next;
  }
  printf("}\n");
}
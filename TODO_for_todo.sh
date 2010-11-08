TODO list for todo.sh

Write a readme file with more complete instructions/notes.

Notes about v.03b
Sanity check for dates works. If you enter a date in the past, it warns you and asks if you want to proceed.
Nadir figured out how to specific fields, and that code allows more than one character in the tag field.
Sorting is still a problem. Even with 'sort -n' or 'sort -h' it still sorts the tag field first. 
Some punctuation in the text field causes pukage. If that happens, put quotes around the text entry.
Semi-colons and parentheses do it. I don't know what else.



Note about the name.
I've been calling it todo.  Telemachus started using tasker. There's alreay an android app called tasker. There's also one called task that's in the debian repos. There's also a tasky and a tasque. I came up with taskfer. Nadir likes it. So I started using it inside the script.
Taskfer carries your tasks. I wish it would do mine for me.






#WISHLIST
# add a deleter/reminder for stuff which is already in the past
# Export sorted lists to file
# Find a use for date-of-entry field?



These are done except for the colors. That seems to be inconsistent.
- Display entries by date they were entered? Is this on anyone's wishlist?
- Figure out how to do somthing like:
    if x is in field y, do something
- Right now, the script exits after it does almost any task. Should it keep running?
 e.g. Maybe for deleting a line, it should loop and ask if you want to delete another.
      (Put a while loop in the function)
- Disable colors in my nano. Holy shit.



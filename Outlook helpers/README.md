Small programs to help handling and managing emails etc.

| Program  | Language(s) | Description |
|---|---|---|
| change_current_view.vba | VBA | Multiple users managing same inbox can sometimes be difficult because of how Outlook handles views and multiple users. This might lead to sudden changes of view. This script restores the view to a desired view. Can be used as a macro and bind to GUI button etc.|
| clearRepliedProperty.vba | VBA | Outlook adds "You have replied/forwarded..." text to an email if a user starts to reply to a email message and keeps the mail window open for x amount of time. The text stays even if user does not send the message and closes the window. In a multiple user environment this can lead to false assumptions that an email has been already replied to and cause unnecessary delay to a customer. This script removes the corresponding Mailitem property and thus removes the text.|
| outlook_itemscount.vba | VBA | Iterates through multiple email folders and counts the number of messages.|
| outlook_oldestitems.vba | VBA | This script is used to manage old and archived emails to follow guidelines of GDPR regulation. The script iterates through multiple email folders and finds the olders email per folder. |
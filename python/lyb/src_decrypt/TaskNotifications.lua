
TaskNotifications={
                          TASK_INIT_COMMOND="TASK_INIT_COMMOND",
                          OPEN_MODAL_DIALOG_COMMOND="OPEN_MODAL_DIALOG_COMMOND",
                          TASK_CLOSE_COMMOND="TASK_CLOSE_COMMOND",
                          NPC_DIALOG_TASK_CLOSE_COMMOND="NPC_DIALOG_TASK_CLOSE_COMMOND",
                          MODAL_DIALOG_CLOSE_COMMOND="MODAL_DIALOG_CLOSE_COMMOND"
                          };

TaskNotification=class(Notification);

function TaskNotification:ctor(type_string,data)
	self.class = TaskNotification;
	self.type = type_string;
  self.data = data;
end
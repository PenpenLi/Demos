MeetingNotifications = {
				   MEETING_CLOSE_COMMAND="MEETING_CLOSE_COMMAND"
				   };

MeetingNotification=class(Notification);

function MeetingNotification:ctor(type_string,data)
	self.class = MeetingNotification;
	self.type = type_string;
  self.data = data;
end

function MeetingNotification:getData()
  return self.data;
end
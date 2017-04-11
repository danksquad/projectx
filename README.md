Gathr

Description:
Gathr is an event planning and group messaging app that puts the events at the focus.  Users are notified when they are invited to events that are hosted by their peers. From there, they can group message with everyone going to that event.

Required user stories:
As a user, I want to be able to chat with other people that are going to the same event, so that I can better coordinate.
As a host, I want to be able to invite people to my events, so that I can see how many people are coming.
As a user, I want to know when people invite me to their events, so that I can always stay up to date with when people want to meet.
As a user, I want to see all of the events that said I am going to, so that I can easily see my event agenda for the day.
As a user, I want to have notifications to remind me when the event is starting, so that I won’t be late to the event.

Optional user stories:
As a user, I want to be able to see the event I have planned for today in a map view, so I can better arrange I will be throughout the day
As a host, I want to be able to connect to Facebook, so that I can invite my Facebook friends to the events.
As a user, I want to be able to see where all of my friends are at the event, so that I can better locate them in a crowd.
As a user, I want get recommendations of people that have encountered 3 or more times at an event, so that I can make new friends.
As a user, I want be able to send stickers, so that my conversations are lit.
As a user, I want to be able to take pictures of the event and save it to a "story", so that I can share the event highlights later on.
As a host, I want to automatically notify my attendees if they are late to the event, so that they feel guilty.

Heroku Link:
https://damp-caverns-14732.herokuapp.com/

Database Schema:

--User--
ID: String
FirstName: String
LastName: String
UserName: String
Password: String
ProfilePic: Image

--Event--
ID: String
Name: String
StartTime: NSDate
EndTime: NSDate
Location: String
Supplies: Array of Strings
Description: String

--Message--
ID: String
TimeSent: NSDate
SentByID: String
SendToID: String
LikeCount: Int
Text: String


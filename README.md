Gathr

Description:
Gathr is an event planning and group messaging app that puts the events at the focus.  Users are notified when they are invited to events that are hosted by their peers. From there, they can group message with everyone going to that event.

Required user stories: <br />
As a user, I want to be able to login, so that I can access my account. <br />
As a user, I want to be able to create a new event, so that I can share it with others. <br />
As a user, I want to see event details, so that I know specifics about the event. <br />
As a user, I want to be able to chat with other people that are going to the same event, so that I can better coordinate. <br />
As a host, I want to be able to invite people to my events, so that I can see how many people are coming. <br />
As a user, I want to know when people invite me to their events, so that I can always stay up to date with when people want to meet. <br />
As a user, I want to see all of the events that said I am going to, so that I can easily see my event agenda for the day. <br />
As a user, I want to have notifications to remind me when the event is starting, so that I won’t be late to the event. 

Optional user stories: <br />
As a user, I want to be able to see the event I have planned for today in a map view, so I can better arrange I will be throughout the day <br />
As a user, I want to be able to see where all of my friends are at the event, so that I can better locate them in a crowd. <br />
As a user, I want be able to send stickers, so that my conversations are lit. <br />
As a user, I want to be able to take pictures of the event and save it to a "story", so that I can share the event highlights later on. <br />
As a host, I want to automatically notify my attendees if they are late to the event, so that they feel guilty.

Heroku Link: <br />
https://damp-caverns-14732.herokuapp.com/ 

Database Schema:

--User-- <br />
user_id: String <br />
first_name: String <br />
last_name: String <br />
username: String <br />
password: String <br />
profile_pic: Image 

--Event-- <br />
room_id: String <br />
name: String <br />
start_time: NSDate <br />
end_time: NSDate <br />
location: String <br />
supplies: Array of Strings <br />
description: String

--Message-- <br />
time_sent: NSDate <br />
sent_by: String <br />
likes: Int <br />
text: String

Image credits:

<a href="https://icons8.com/icon/532/News">News icon credits</a><br />
<a href="https://icons8.com/icon/23/calendar">Calendar icon credits</a><br />
<a href="https://icons8.com/icon/3225/user">User icon credits</a><br />
<a href="https://icons8.com/icon/23265/user-filled">User-filled icon credits</a>

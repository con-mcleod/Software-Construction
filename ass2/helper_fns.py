#!/usr/bin/python3

import os, sqlite3, re
from routing import *
from server import *
from flask_login import UserMixin, LoginManager,login_user, current_user, login_required, logout_user
from datetime import datetime

#######################
# Database Handling
#######################
DATABASE = "talk.db"

def dbselect(query, payload):
	connection = sqlite3.connect(DATABASE)
	cursorObj = connection.cursor()
	if not payload:
		rows = cursorObj.execute(query)
	else:
		rows = cursorObj.execute(query,payload)
	results = []
	for row in rows:
		results.append(row)
	cursorObj.close()
	return results

def dbexecute(query, payload):
	connection = sqlite3.connect(DATABASE)
	cursor = connection.cursor()
	if not payload:
		cursor.execute(query)
	else:
		cursor.execute(query, payload)
	connection.commit()
	connection.close()

#######################
# User Class
#######################
class User(UserMixin):
	def __init__(self, id):
		self.id = id

	@property
	def user_id(self):
		return self.id

#######################
# User Methods
#######################
def get_user(user_id):
	return User(user_id)

@login_manager.user_loader
def load_user(user_id):
	user = get_user(user_id)
	return user

def check_zid(zid):
	zid = re.sub(r'[^0-9]','',zid)
	query = "SELECT zid from student where zid = ?"
	payload = (zid,)
	result = dbselect(query, payload)
	if not result:
		return False
	return True

def check_zid_available(zid):
	zid = re.sub(r'[^0-9]','',zid)
	query = "SELECT zid from student where zid = ?"
	payload = (zid,)
	result = dbselect(query, payload)
	if not result:
		return True
	return False

def check_pw(zid, pw):
	query = "SELECT password from student where zid = ?"
	payload = (zid,)
	correct_password = dbselect(query, payload)[0][0]
	if pw == correct_password:
		user = get_user(zid)
		login_user(user)
		return True
	return False

def save_pw(zid, pw):
	query = "INSERT OR IGNORE into student (zid, password) VALUES (?,?)"
	payload = (zid, pw,)
	dbexecute(query, payload)
	user = get_user(zid)
	login_user(user)

def get_name(zid):
	query = "SELECT name from student where zid = ?"
	payload = (zid,)
	name = dbselect(query, payload)[0][0]
	return name

def get_zid(name):
	query = "SELECT zid from student where name = ?"
	payload = (name, )
	zid = dbselect(query, payload)[0][0]
	return zid

def get_enrolled_course_IDs(zid):
	query = "SELECT course_id from enrolment e join student s where s.zid = ? and e.zid=s.zid"
	payload = (zid, )
	course_IDs = dbselect(query, payload)
	return course_IDs

#######################
# Dashboard
#######################
def add_post(zid, msg):
	get_time = str(datetime.now())
	date = re.sub(r'\s.*$','',get_time)
	time = re.sub(r'^.*\s','',get_time)
	time = re.sub(r'\..*$','',time)
	query = "INSERT OR IGNORE into posts (zid, msg, submit_date, submit_time) VALUES (?,?,?,?)"
	payload = (zid, msg, date, time, )
	dbexecute(query, payload)

def get_own_posts(zid):
	query = "SELECT name, msg, submit_date, id from posts m join student s where s.zid=? and m.zid = s.zid"
	payload = (zid,)
	posts = dbselect(query, payload)
	if posts is not None:
		sorted_posts = sorted(posts, key = lambda x: x[2], reverse=True)
	return sorted_posts

def get_comments(posts):
	comments = []
	for post in posts:
		query = "SELECT id, parent_id, zid, msg, submit_date, submit_time from comments where parent_id=?"
		payload = (post[3],)
		comments.append(dbselect(query, payload))
	return comments

def get_friends_posts(friends_list):
	query = "SELECT name, msg, submit_date, id from posts m join student s where s.zid=? and m.zid = s.zid"
	friends_posts = []
	for friend in friends_list:
		friend_zid = get_zid(friend[0])
		payload = (friend_zid,)
		friends_posts.append(dbselect(query, payload))
	# to do: sort a list of lists

	return friends_posts

def get_friends_comments(posts):
	comments = []
	for friend in posts:
		for post in friend:
			query = "SELECT id, parent_id, zid, msg, submit_date, submit_time from comments where parent_id=?"
			payload = (post[3],)
			comments.append(dbselect(query, payload))
	return comments


def get_friends(zid):
	query = "SELECT name from student s join friends f where f.zid1=? and f.zid2=s.zid and f.request = 0"
	payload = (zid,)
	friend_list = dbselect(query, payload)
	return friend_list

def suggested_friends(zid):
	query = "SELECT zid from enrolment e join course c where e.course_id=? and e.course_id = c.id and e.zid!=?"
	sugg_name = []
	course_IDs = get_enrolled_course_IDs(zid)
	for courseID in course_IDs:
		courseID = courseID[0]
		payload = (courseID, zid)
		result = dbselect(query, payload)
		for sugg_friend in result:
			sugg_friend = get_name(sugg_friend[0])
			if sugg_friend not in sugg_name:
				sugg_name.append(sugg_friend)

		curr_friends = get_friends(zid)
		for friend in curr_friends:
			if friend[0] in sugg_name:
				sugg_name.remove(friend[0])
	return sugg_name

#######################
# Profile
#######################

def get_student_details(zid):
	query = "SELECT name, email, birthday, program, description from student where zid=?"
	payload = (zid,)
	details = dbselect(query, payload)
	return details

def get_all_details(zid):
	query = "SELECT name, email, password, home_suburb, home_longitude, home_latitude, birthday, program, description from student where zid=?"
	payload = (zid,)
	details = dbselect(query, payload)
	return details

def get_photo(zid):
	pass

def save_details(zid, name, email, pw, bday, suburb, longitude, latitude, program, description):
	suspended=0
	query = "INSERT OR replace into student (zid, password, name, email, birthday, home_suburb, home_longitude, home_latitude, program, description, suspended) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
	payload = (zid, pw, name, email, bday, suburb, longitude, latitude, program, description, suspended)
	dbexecute(query, payload)



# Suspending/Deleting accounts not implemented system-wide so I have ignored
def suspend_acct(zid):
	suspended = 1
	pass

def reactivate_acct(zid):
	suspended = 0
	pass

def delete_acct(zid):
	pass

#######################
# Other Profile
#######################
def check_if_friends(my_zid, zid):
	query = "SELECT zid1, zid2 from friends where zid1=? and zid2=? and request=0"
	payload = (my_zid, zid)
	result = dbselect(query, payload)
	if result:
		return True
	return False

def delete_friend(my_zid, zid):
	query = "DELETE from friends where zid1=? and zid2=?"
	payload = (my_zid, zid)
	dbexecute(query, payload)
	payload = (zid, my_zid)
	dbexecute(query, payload)

def request_friend(my_zid, zid):
	request = 1
	query = "INSERT into friends (zid1, zid2, request) VALUES (?,?,?)"
	payload = (my_zid, zid, request)
	dbexecute(query, payload)

def check_if_requested(my_zid, zid):
	query = "SELECT zid1, zid2 from friends where zid1=? and zid2=? and request=1"
	payload = (my_zid, zid)
	results = dbselect(query, payload)
	if results:
		return True
	return False

def cancel_request(my_zid, zid):
	query = "DELETE from friends where zid1=? and zid2=? and request=1"
	payload = (my_zid, zid)
	dbexecute(query, payload)

#######################
# Notifications
#######################
def get_friend_requests(zid):
	query = "SELECT zid1, name from friends f join student s where f.zid2=? and f.request=1 and f.zid1=s.zid"
	payload = (zid,)
	results = dbselect(query, payload)
	return results

def accept_friend_request(my_zid, accepted_zid):
	query = "DELETE from friends where zid1=? and zid2=? and request=1"
	payload = (my_zid, accepted_zid)
	dbexecute(query, payload)
	payload = (accepted_zid, my_zid)
	dbexecute(query, payload)
	request = 0
	query = "INSERT into friends (zid1, zid2, request) VALUES (?,?,?)"
	payload = (my_zid, accepted_zid, request)
	dbexecute(query, payload)
	payload = (accepted_zid, my_zid, request)
	dbexecute(query, payload)

#######################
# Search Functionality
#######################

def query_search_people(search_string):
	name_results = []
	query = "SELECT name from student where name like ?"
	payload = ('%' + search_string + '%',)
	name_results.append(dbselect(query, payload))
	
	return name_results

def query_search_posts(search_string):
	post_results = []
	query = "SELECT msg from posts where msg like ?"
	payload = ('%' + search_string + '%',)
	post_results.append(dbselect(query, payload))

	return post_results
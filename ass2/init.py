#!/usr/bin/env python3

import sys, sqlite3, os, glob, re, shutil

if (len(sys.argv) != 3):
	print ("Usage: python3 init.py [dataset_directory] talk.db")
	exit(1)

dataset = sys.argv[1]
DATABASE = sys.argv[2]

if(os.path.exists(DATABASE)):
	os.remove(DATABASE)

connection = sqlite3.connect(DATABASE)
cursor = connection.cursor()

cursor.execute("""CREATE TABLE student(
	zid INTEGER primary key,
	password TEXT,
	name TEXT default "Name",
	email TEXT default "Email",
	birthday DATE,
	home_suburb TEXT,
	home_longitude FLOAT,
	home_latitude FLOAT,
	program TEXT default "Program",
	description TEXT default "Your personal description",
	suspended INTEGER NOT NULL check (suspended IN(0,1))
	)""")

cursor.execute("""CREATE TABLE friends(
	zid1 INTEGER,
	zid2 INTEGER,
	request INTEGER DEFAULT 0 check (request IN(0,1)),
	constraint friends_pk primary key(zid1, zid2),
	foreign key (zid1) references student(zid),
	foreign key (zid2) references student(zid)
	)""")

cursor.execute("""CREATE TABLE enrolment(
	zid INTEGER,
	course_id INTEGER,
	constraint enrolment_pk primary key (zid, course_id),
	foreign key (zid) references student(zid),
	foreign key (course_id) references course(id)
	)""")

cursor.execute("""CREATE TABLE course(
	id INTEGER primary key autoincrement,
	course_code TEXT,
	semester TEXT,
	year INTEGER,
	unique(course_code, semester, year)
	)""")

cursor.execute("""CREATE TABLE posts(
	id INTEGER primary key autoincrement,
	zid INTEGER,
	msg TEXT,
	submit_date DATE,
	submit_time TIME,
	longitude FLOAT,
	latitude FLOAT,
	file_details TEXT,
	unique (zid, msg, submit_date, submit_time)
	foreign key (zid) references student(zid)
	)""")

cursor.execute("""CREATE TABLE comments(
	id INTEGER primary key autoincrement,
	zid INTEGER,
	msg TEXT,
	submit_date DATE,
	submit_time TIME,
	parent_id INTEGER,
	file_details TEXT, 
	foreign key (parent_id) references posts(id)
	foreign key (zid) references student(zid)
	)""")

cursor.execute("""CREATE TABLE reply(
	id INTEGER primary key autoincrement,
	zid INTEGER,
	msg TEXT,
	submit_date DATE,
	submit_time TIME,
	parent_id INTEGER,
	file_details TEXT, 
	foreign key (parent_id) references comments(id)
	foreign key (zid) references student(zid)
	)""")

cursor.execute("""CREATE TABLE mention(
	id INTEGER primary key autoincrement,
	msg_type INTEGER NOT NULL check (msg_type IN(0,1,2)),
	msg_id INTEGER,
	msg TEXT,
	zid INTEGER
	)""")

mentions = []
student_folders = os.path.join(dataset,"*")
for path in glob.glob(student_folders):
	
	zid = re.sub(r"[^0-9]", "", path)
	zid_tag = re.compile(r'z([0-9]{7})')
	
	# handle student.txt
	student_details = os.path.join(path,"student.txt")
	with open(student_details) as details:
		for line in details:
			if "password:" in line:
				password = line.split(": ")[1].rstrip()
			elif "full_name:" in line:
				name = line.split(": ")[1].rstrip()
			elif "email:" in line:
				email = line.split(": ")[1].rstrip()
			elif "birthday:" in line:
				birthday = line.split(": ")[1].rstrip()
			elif "home_suburb:" in line:
				home_suburb = line.split(": ")[1].rstrip()
			elif "home_longitude:" in line:
				home_longitude = line.split(": ")[1].rstrip()
			elif "home_latitude:" in line:
				home_latitude = line.split(": ")[1].rstrip()
			elif "program:" in line:
				program = line.split(": ")[1].rstrip()
			elif "courses:" in line:
				line = line.split(": ")[1]
				courses = line.split(", ")
				for course in courses:
					course = re.sub(r'(\(|\)|\,)',"",course)
					year = course.split(" ")[0]
					semester = course.split(" ")[1]
					course_code = course.split(" ")[2].rstrip()
					cursor.execute("""INSERT OR IGNORE INTO course (course_code, semester, year)
						VALUES (?,?,?)""", (course_code, semester, year)
					)
					cursor.execute("""SELECT id from course 
						where course_code=? and semester=? and year=?"""
						, (course_code,semester,year)
					)
					course_id = cursor.fetchall()[0][0]					
					cursor.execute("""INSERT INTO enrolment (zid, course_id)
						VALUES (?,?)""", (zid, course_id)
					)
			elif "friends" in line:
				line = line.split(": ")[1]
				friends = line.split(", ")
				for friend in friends:
					friend = re.sub(r'([^0-9])',"",friend)
					cursor.execute("""INSERT OR IGNORE into friends(zid1, zid2)
						VALUES (?,?)""", (zid, friend)
					)
					cursor.execute(""" INSERT OR IGNORE into friends(zid1,zid2)
						VALUES (?,?)""", (friend, zid)
					)
	description = "Your personal description"
	suspended = 0
	cursor.execute("""INSERT INTO student (zid, password, name, email, birthday, home_suburb, home_longitude, home_latitude, program, suspended, description)
		VALUES (?,?,?,?,?,?,?,?,?,?,?)""",
		(zid, password, name, email, birthday, home_suburb, home_longitude, home_latitude, program, suspended, description)
	)

	# handle img.jpg
	image_file = os.path.join(path, "img.jpg")
	if os.path.exists(image_file):
		new_location = os.path.join('static/profile_pics', zid + ".jpg")
		image_file = "/" + shutil.copyfile(image_file, new_location)

	# handle posts
	content_files = os.path.join(path, "*")
	for file in glob.glob(content_files):

		file = file.split("/")[2]
		file = re.sub(r'[^0-9\-]*',"",file)
		post_file = re.compile("^[0-9]+$")

		if post_file.match(file):
			post_file = os.path.join(path, file + ".txt")
			file_details = file
			msg_type = 0
			with open(post_file) as post:
				for line in post:
					if "message:" in line:
						msg = line.split(": ",1)[1].rstrip()
						msg = re.sub(r'\n',"",msg)
						mentions = zid_tag.findall(msg);
						if mentions is not None:
							for mention in mentions:
								zid_string = re.sub(r'[^0-9\s]','',mention)
								zids = zid_string.split('\s+')
								cursor.execute("""INSERT OR IGNORE INTO mention (msg_type, msg_id, msg, zid)
									VALUES (?,?,?,?)""", (msg_type, parent_id, msg, zids))
					elif "time:" in line:
						time = line.split('T')[1].rstrip()
						date = line.split(": ")[1].split('T')[0]
					elif "longitude:" in line:
						longitude = line.split(": ")[1].rstrip()
					elif "latitude:" in line:
						latitude = line.split(": ")[1].rstrip()
			cursor.execute("""INSERT OR IGNORE INTO posts (zid, msg, submit_date, submit_time, longitude, latitude, file_details)
				VALUES (?,?,?,?,?,?,?)""",
				(zid, msg, date, time, longitude, latitude, file_details)
			)
	
	# handle comments
	for file in glob.glob(content_files):

		file = file.split("/")[2]
		file = re.sub(r'[^0-9\-]*',"",file)
		comment_file = re.compile("^[0-9]+-[0-9]+$")

		if comment_file.match(file):
			zid = re.sub(r"[^0-9]", "", path)
			post_id = re.sub(r'-.*$','',file)
			msg_type = 1

			cursor.execute("""SELECT id from posts 
				where zid=? and file_details=?"""
				, (zid,post_id)
			)
			parent_id = cursor.fetchall()[0][0]

			comment_file = os.path.join(path, file + ".txt")
			with open(comment_file) as comment:
				for line in comment:
					if "from:" in line:
						zid = line.split(": ")[1].rstrip()
					elif "message:" in line:
						msg = line.split(": ",1)[1].rstrip()
						msg = re.sub(r'\n',"",msg)
						mentions = zid_tag.findall(msg);
						if mentions is not None:
							for mention in mentions:
								zid_string = re.sub(r'[^0-9\s]','',mention)
								zids = zid_string.split('\s+')
								for student_id in zids:
									cursor.execute("""INSERT OR IGNORE INTO mention (msg_type, msg_id, msg, zid)
									VALUES (?,?,?,?)""", (msg_type, parent_id, msg, student_id))
					elif "time:" in line:
						time = line.split('T')[1].rstrip()
						date = line.split(": ")[1].split('T')[0]

			cursor.execute("""INSERT OR IGNORE INTO comments (zid, msg, submit_date, submit_time, parent_id, file_details)
				VALUES (?,?,?,?,?,?)""",
				(zid, msg, date, time, parent_id, file)
			)

	# handle replies
	for file in glob.glob(content_files):

		file = file.split("/")[2]
		file = re.sub(r'[^0-9\-]*',"",file)
		reply_file = re.compile("^[0-9]+-[0-9]+-[0-9]+$")

		if reply_file.match(file):
			zid = re.sub(r"[^0-9]", "", path)
			post_id = re.sub(r'-.*$','',file)
			comment_id = re.sub(r'^[0-9]+','',file)
			comment_id = re.sub(r'[0-9]+$','',comment_id)
			comment_id = re.sub(r'-','',comment_id)
			file_details = str(post_id + "-" + comment_id)
			msg_type = 2

			cursor.execute("""SELECT id from comments where file_details=?"""
				, (file_details,)
			)
			parent_id = cursor.fetchall()[0][0]

			reply_file = os.path.join(path, file + ".txt")
			with open(reply_file) as reply:
				for line in reply:
					if "from:" in line:
						zid = line.split(": ")[1].rstrip()
					elif "message:" in line:
						msg = line.split(": ",1)[1].rstrip()
						msg = re.sub(r'\n',"",msg)
						mentions = zid_tag.findall(msg);
						if mentions is not None:
							for mention in mentions:
								zid_string = re.sub(r'[^0-9\s]','',mention)
								zids = zid_string.split('\s+')
								for student_id in zids:
									cursor.execute("""INSERT OR IGNORE INTO mention (msg_type, msg_id, msg, zid)
									VALUES (?,?,?,?)""", (msg_type, parent_id, msg, student_id))
					elif "time:" in line:
						time = line.split('T')[1].rstrip()
						date = line.split(": ")[1].split('T')[0]

			cursor.execute("""INSERT OR IGNORE INTO reply (zid, msg, submit_date, submit_time, parent_id, file_details)
				VALUES (?,?,?,?,?,?)""",
				(zid, msg, date, time, parent_id, file_details)
			)




connection.commit()
connection.close()

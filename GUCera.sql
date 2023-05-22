create DATABASE GUCera

Go 

USE GUCera
----insert into users values('mohamed','l1ll',1123,0,'mohamed','a1')
--insert into Instructor values(14,1)
--select*from users
--select gender from users
--drop table users
--select*from Course
CREATE TABLE Users(
id int IDENTITY PRIMARY KEY,
firstName varchar(10),
lastName varchar(10),
password varchar(10),
gender binary,
email varchar(50) UNIQUE,
address varchar(10),
);
--select*from student


CREATE TABLE Instructor(
id int PRIMARY KEY REFERENCES Users(id) on DELETE CASCADE on UPDATE CASCADE,
rating DECIMAL(2,1)
);

CREATE TABLE UserMobileNumber(
id int REFERENCES users(id) on DELETE CASCADE on UPDATE CASCADE,
mobileNumber varchar(11),
PRIMARY KEY(id, mobileNumber)
);


CREATE TABLE Student (
id int PRIMARY KEY REFERENCES Users(id) on DELETE CASCADE on UPDATE CASCADE,
gpa DECIMAL(3,2),

);


CREATE TABLE Admin(
id int PRIMARY KEY REFERENCES Users(id) on DELETE CASCADE on UPDATE CASCADE,
);
--insert into course values(2,'Math2','ff',2.9,'ee',13,14,1)
--insert into course values(2,'CS','ff',2.9,'ee',13,14,1)
--F:\database\M3\Milestone 2 Solution_34659.sql
--select*from course
CREATE TABLE Course(
id int IDENTITY PRIMARY KEY,
creditHours int,
name varchar(10) UNIQUE,
courseDescription varchar(200), 
price DECIMAL(6,2),
content varchar(200),
adminId int REFERENCES Admin(id) on DELETE No ACTION on UPDATE No ACTION,
instructorId int REFERENCES Instructor(id) on DELETE CASCADE on UPDATE CASCADE,
accepted BIT
);



CREATE TABLE Assignment(
cid int REFERENCES Course(id) on DELETE CASCADE on UPDATE CASCADE,
number int,
type varchar(10),
fullGrade int,
weight decimal(4,1),
Check (weight between 0 and 100),
deadline datetime,
content varchar(200),
CHECK (type in ('quiz', 'exam', 'project')),
PRIMARY KEY(cid, number,type)
);

CREATE TABLE Feedback(
cid int REFERENCES Course(id) on DELETE NO ACTION on UPDATE NO ACTION,
number int identity,
comment varchar(100),
numberOfLikes int DEFAULT 0,
sid int REFERENCES Student(id) on DELETE SET NULL on UPDATE CASCADE,
PRIMARY KEY(cid, number)
);
--drop table Users
--insert into Promocode values('second','01/01/2020','01/01/2020',2.3,13)
--select*from student
--insert into admin values(13)
CREATE TABLE Promocode(
code varchar(6) PRIMARY KEY,
isuueDate datetime,
expiryDate datetime,
discount decimal(4,2),
adminId int REFERENCES Admin(id) on DELETE SET NULL on UPDATE CASCADE,
);
--select*from creditcard
--insert into StudentHasPromocode values(2,'second')
CREATE TABLE StudentHasPromocode(
sid int REFERENCES Student(id) on DELETE NO ACTION on UPDATE NO ACTION,
code varchar(6) REFERENCES Promocode(code) on DELETE CASCADE on UPDATE CASCADE,
PRIMARY KEY (sid, code)
);
--select*from CreditCard
CREATE TABLE CreditCard(
number varchar(15) PRIMARY KEY,
cardHolderName varchar(16),
expiryDate datetime,
cvv varchar(3)
);
--select*from course
CREATE TABLE StudentAddCreditCard(
sid int REFERENCES Student(id) on DELETE CASCADE on UPDATE CASCADE,
creditCardNumber varchar(15) REFERENCES CreditCard on DELETE CASCADE on UPDATE CASCADE
PRIMARY KEY (sid, creditCardNumber)
);

CREATE TABLE StudentTakeCourse(
sid int REFERENCES Student(id) on DELETE CASCADE on UPDATE CASCADE,
cid int REFERENCES Course(id) on DELETE NO ACTION on UPDATE NO ACTION,
insid int REFERENCES Instructor(id) on DELETE NO ACTION on UPDATE NO ACTION,
payedfor BIT,
grade decimal(5,2),
Check (grade between 0 and 100),
PRIMARY KEY (sid, cid, insid) 
);


CREATE TABLE StudentTakeAssignment(
sid int REFERENCES Student(id) on DELETE CASCADE on UPDATE CASCADE,
cid int, 
assignmentNumber int,
assignmenttype varchar(10),
grade decimal(5,2),
Check (grade between 0 and 100),
PRIMARY KEY(sid, cid, assignmentNumber,assignmenttype),
Foreign KEY (cid, assignmentNumber,assignmenttype) REFERENCES Assignment(cid, number,type) on DELETE No Action on UPDATE No Action, 
);


CREATE TABLE StudentRateInstructor(
sid int REFERENCES Student(id) on DELETE CASCADE on UPDATE CASCADE,
insid int REFERENCES Instructor(id) on DELETE No Action on UPDATE No Action,
rate DECIMAL(2,1),
PRIMARY KEY(sid, insid)
);

CREATE TABLE StudentCertifyCourse(
sid int REFERENCES Student(id) on DELETE CASCADE on UPDATE CASCADE,
cid int REFERENCES Course(id) on DELETE No Action on UPDATE No Action,
issueDate datetime,
PRIMARY KEY(sid, cid)
);

CREATE TABLE CoursePrerequisiteCourse(
cid int REFERENCES Course(id) on DELETE CASCADE on UPDATE CASCADE,
preid int REFERENCES Course(id) on DELETE No Action on UPDATE No Action,
PRIMARY KEY(cid, preid)
);
--drop table Users 


CREATE TABLE InstructorTeachCourse(
insid int REFERENCES Instructor(id) on DELETE CASCADE on UPDATE CASCADE,
cid int REFERENCES Course(id) on DELETE No Action on UPDATE No Action,
PRIMARY KEY(insid, cid),
);
/*
insert into InstructorTeachCourse values(1018,5)

select * from StudentTakeCourse

select * from instructor
select * from users

*/


go
----------------------------------------

/*go
declare @x varchar(20)

declare @y int

exec userLogin 7,123,@x output,@y output
--@x=q
print(@x)*/
--drop proc UpdateCourseContent
go
Create proc userLogin
@id int,
@password varchar(20),
@success bit output,
@type int output
as
begin
if exists(
select ID,password
from users
where id=@id and password=@password)
begin
set @success =1
-- check user type 0-->Instructor,1-->Admin,2-->Student
if exists(select id from Instructor where id=@id)
set @type=0
if exists(select id from Admin where id=@id)
set @type=1
if exists(select id from Student where id=@id)
set @type=2
end
else 
begin
set @success=0
set @type=-1
end
end
go
/*exec studentRegister 'nouraaaa0000000000aa','--','12','nooounrmm',9,'aaa'
'aya1','l1ll',1123,1,'a1aa','a1')
insert into StudentTakeCourse (sid,cid,insid) values (2,3,14)
insert into StudentTakeCourse (sid,cid,insid,payedfor,grade) VALUES (2,3,14,1,85)
select * from StudentTakeCourse
insert into StudentCertifyCourse (sid,cid,issueDate) values (2,3,'3/3/2003')
*/
/*select gender from users
if(exists(select gender from users where gender=0x01))
print'helo'
delete from student*/
--select *from users 1234567891
--------------------------------------------------------------
--drop proc studentRegister
--select*from users
/*declare @a  int
declare @b int
exec studentRegister '123456789012','','','box',1,'',@a output,@b output
print @a 
print @b*/
--select*from Users
--drop proc studentRegister
go
create proc studentRegister
@first_name varchar(10),
@last_name varchar(10),
@password varchar(10),
@email varchar(10),
@gender bit,
@address varchar(10),
@id1 int output,
@CM bit output
as
begin
if(exists(select * from users where email=@email))
begin
set @CM=1
print'There is a user with this email'
end
else
begin
set @CM=0

insert into users(firstName,lastName,password,email,gender,address)
values(@first_name,@last_name,@password,@email,@gender,@address)
declare @id int
SELECT @id=SCOPE_IDENTITY()
insert into Student values(@id,0)
set @id1=@id
end
end

--select *from users
go  

----------------------------------------------------
create proc InstructorRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(10),
@gender bit,
@address varchar(10),
@id1 int output,
@CM bit output
as
begin
if(exists(select * from users where email=@email))
begin
set @CM=1
print'There is a user with this email'
end
else
begin
set @CM=0
insert into users(firstName,lastName,password,email,gender,address)
values(@first_name,@last_name,@password,@email,@gender,@address)
declare @id int
SELECT @id=SCOPE_IDENTITY()
insert into Instructor values(@id,0)
set @id1=@id
end
end
go  
--select*from UserMobileNumber
-------------------------------------------------------------
--exec addMobile 1,'1234567889123'
--select *from UserMobileNumber where id=1
--drop proc addMobile
create proc addMobile
@ID varchar(20),
@mobile_number varchar(20)
as
begin
if @ID is not null and @mobile_number is not null
insert into UserMobileNumber values(@ID,@mobile_number)
end
go

-------------------------------------------------------------
--- 1 List all instructors in the system ----

CREATE Proc AdminListInstr
As
Select u.firstName, u.lastName
from Users u inner join Instructor i on u.id = i.id
go


--- 2 view the profile of any instructor that contains all his/her information -----
CREATE Proc AdminViewInstructorProfile
@instrId int
As
Select u.firstName, u.lastName, u.gender, u.email, u.address, i.rating
from Users u inner join Instructor i on u.id = i.id
WHERE @instrId = i.id
go

--- 3 List all courses in the system ------
CREATE Proc AdminViewAllCourses
As
Select name, creditHours, price, content, accepted
From Course
go


--- 4 List all the courses added by instructors not yet accepted ----
CREATE Proc AdminViewNonAcceptedCourses
As
Select name, creditHours, price, content
From Course
Where accepted = 0 or accepted is null


Go

---- 5 View any course details such as course description and content ----
CREATE Proc AdminViewCourseDetails
@courseId int
As
Select name, creditHours, price, content, accepted
From Course
Where @courseId = id

Go

--- 6 Accept/Reject any of the requested courses that are added by instructors ---
CREATE Proc AdminAcceptRejectCourse
@adminid int,
@courseId int
As
UPDATE Course
SET accepted = 1 , adminId=@adminid
Where id = @courseId

Go
--- 7 Create new Promo codes by inserting all promo code detail ---
CREATE Proc AdminCreatePromocode
@code varchar(6),
@isuueDate datetime,
@expiryDate datetime,
@discount decimal(4,2),
@adminId int
As
IF @code is Null or
@isuueDate is Null or 
@expiryDate is Null or
@discount is Null or
@adminId is Null
Print 'Cannot create promocode'
Else
Insert into Promocode Values(@code,@isuueDate,@expiryDate,@discount,@adminId)

Go


--- 8 List all students in the system -----
CREATE Proc AdminListAllStudents
As
Select u.firstName, u.lastName
from Users u inner join Student s on u.id = s.id

Go 

--- 9  view the profile of any student that contains all his/her information ----
CREATE Proc AdminViewStudentProfile
@sid int
As
Select u.firstName, u.lastName, u.gender, u.email, u.address, s.gpa
from Users u inner join Student s on u.id = s.id
WHERE @sid = s.id


Go
----- 10 Issue the promo code created to any student ----
CREATE Proc AdminIssuePromocodeToStudent
@sid int,
@pid varchar(6)
As
If @pid is Null or
@sid is Null
Print 'Error'
Else
Insert into StudentHasPromocode Values(@sid, @pid)

go
-----------------------------------------------------------------
--Instructor
--- 1 Add a new course content and description  ----
-- select * from Feedback
-- select * from users where id =14
--select * from StudentTakeCourse
--exec checkINSteachC 1004
--drop proc checkINSteachC
--delete from StudentTakeCourse   select * from InstructorTeachCourse
CREATE Proc checkINSteachC
@cid int
as
(select u.id as instructorID,u.firstName +' '+ u.lastName +' || with ID:'+cast(u.id as varchar(50))  as name  
from InstructorTeachCourse i inner join Users u on u.id=i.insid  
where i.cid=@cid)
union
(select u.id as instructorID,u.firstName +' '+ u.lastName +' || with ID:'+cast(u.id as varchar(50))  as name  
from Course c inner join Users u on u.id=c.instructorId   
where c.id=@cid)

go
CREATE Proc InstAddCourse
@creditHours int,
@name varchar(10),
@price DECIMAL(6,2),
@instructorId int
As
if(exists(select * from Instructor where id=@instructorId))
Insert into Course(creditHours,name,price,instructorId) values
(@creditHours,@name,@price,@instructorId)
declare @cid int
select @cid = SCOPE_IDENTITY()
insert into InstructorTeachCourse(cid,insid) values(@cid,@instructorId)


go
--- 2 update course content  ----
CREATE Proc UpdateCourseContent
@instrId int,
@courseId int, 
@content varchar(200)
As
if(exists(select * from Course where id=@courseId))
update Course 
set content=@content
where id=@courseId and accepted <>0 and accepted is not null and instructorId=@instrId
go 
----------------------------------------------------------
--- 3 update course description ----
--drop database GUCera
--drop proc UpdateCourseDescription      
go
CREATE Proc UpdateCourseDescription
@instrId int,
@courseId int,
@courseDescription varchar(200)
As
if(exists(select * from Course where id=@courseId))
update Course 
set courseDescription=@courseDescription
where id=@courseId and accepted <>0 and accepted is not null and instructorId=@instrId
go

--- 4 add another instructor to the course  ----here
CREATE Proc AddAnotherInstructorToCourse
@insid int,
@cid int,
@adderIns int
As
if(exists(select * from Course where instructorId=@adderIns and id =@cid ))
if(exists(select * from Course where instructorId=@adderIns and id =@cid ))
Insert into InstructorTeachCourse(insid,cid) values(@insid, @cid)
else 
print 'ERROR'

Go

--- 5 List my courses that were accepted by the admin ----
CREATE Proc InstructorViewAcceptedCoursesByAdmin
@instrId int
As
Select id ,name, creditHours
From Course
Where accepted=1 and instructorId=@instrId
go

----------------------------------------------------------
CREATE Proc DefineCoursePrerequisites
@cid int ,
@prerequsiteId int
As
if(exists(select * from Course where id=@cid))
Insert into CoursePrerequisiteCourse values (@cid,@prerequsiteId)
go
--- 6 Define Assignment of a course of a certian type ----
CREATE Proc DefineAssignmentOfCourseOfCertianType
@instId int,
@cid int ,
@number int,
@type varchar(10),
@fullGrade int,
@weight decimal(4,1),
@deadline datetime,
@content varchar(200)
As
if(exists(select * from Course where id=@cid and instructorId =@instId))
Insert into Assignment values (@cid ,@number,@type,@fullGrade,@weight ,@deadline ,@content)
go

--- 7 Instructor view his profile  ----
CREATE Proc ViewInstructorProfile 
@instrId int
As
Select u.firstName, u.lastName, u.gender, u.email, u.address, i.rating, im.mobileNumber
from Users u inner join Instructor i on u.id = i.id
left outer join  UserMobileNumber im on im.id=u.id
WHERE i.id=@instrId 
go

--- 8 Instructor view assignments of his students  ----

CREATE Proc InstructorViewAssignmentsStudents
@instrId int,
@cid int 
As
Select sid ,cid,assignmentNumber, assignmenttype, grade
From StudentTakeAssignment S inner join course c on s.cid = c.id
Where cid=@cid and c.instructorId =@instrId
go

--- 9 Instructor grade the assignemnt submitted by the student  ----

CREATE Proc InstructorgradeAssignmentOfAStudent 
@instrId int,
@sid int ,
@cid int, 
@assignmentNumber int,
@type varchar(10),
@grade decimal(5,2)
As
if(exists(select * from StudentTakeAssignment S inner join Course C 
on C.id =S.cid where cid=@cid and assignmentNumber=@assignmentNumber and sid=@sid and instructorId= @instrId and assignmenttype=@type))
update StudentTakeAssignment
set grade=@grade
where sid=@sid and cid=@cid and assignmentNumber=@assignmentNumber and assignmenttype =@type
go

--- 10 View feedbacks added by students on my course  ----

CREATE Proc ViewFeedbacksAddedByStudentsOnMyCourse 
@instrId int,
@cid int
As
Select number,comment ,numberOfLikes
From Feedback f inner join course c on c.id = f.cid
Where cid=@cid and instructorId =@instrId 
go

CREATE Proc updateInstructorRate   
@insid int 
As
if(exists(select * from Instructor where id=@insid))
declare @avgRating float
select @avgRating=avg(rate)
from StudentRateInstructor
where insid=@insid

update Instructor 
set rating=@avgRating
where id=@insid

GO
CReate PROC calculateFinalGrade
@cid int ,
@sid int ,
@insId int
AS
BEGIN
declare @fullGrade int 
select @fullGrade=Sum ((weight/100)*fullgrade ) 
From Assignment
where cid=@cid

declare @studentScore int 
select @studentScore=sum(grade)
from StudentTakeAssignment
where sid=@sid and cid=@cid

update StudentTakeCourse
set grade =@studentScore
where cid=@cid and sid=@sid and insid=@insId

END

GO
--- 12 instructor issue certificate to a student   ----
Create Proc InstructorIssueCertificateToStudent
@cid int ,
@sid int ,
@insId int,
@issueDate datetime 
As
if(
exists(select * from StudentTakeCourse where sid=@sid and grade >2.0 and cid=@cid and insid=@insId ))
Insert into StudentCertifyCourse values (@sid,@cid,@issueDate)

GO
-----------------------------------------------------------------------
--Student

CREATE FUNCTION checkStudentEnrolledInCourse
(@sid INT, @cid INT)
RETURNS BIT
BEGIN
DECLARE @returnValue BIT
IF(EXISTS(SELECT * FROM StudentTakeCourse WHERE sid = @sid AND cid = @cid))
SET @returnValue = '1'
ELSE
SET @returnValue = '0'
RETURN @returnValue
END
-- exec viewMyProfile 8
--select * from student
--drop proc payCourse
--exec viewMyProfile 2
--exec availableCourses
--select gender
--from users
go
CREATE PROC viewMyProfile
@id int 
AS
BEGIN
IF (EXISTS(Select * FROM Users WHERE id = @id  ))
SELECT * FROM Student INNER JOIN Users ON Student.id = Users.id
where users.id=@id
ELSE
print 'User not found'
END
go

CREATE PROC editMyProfile
@id int,
@firstName varchar(10),
@lastName varchar(10),
@password varchar(10),
@gender binary,
@email varchar(10),
@address varchar(10)
AS
IF (EXISTS(SELECT * FROM Users WHERE id=@id))
BEGIN
IF (@firstName IS NOT NULL )
UPDATE Users SET firstName = @firstName WHERE id=@id
IF (@lastName IS NOT NULL)
UPDATE Users SET lastName = @lastName WHERE id=@id
IF (@password IS NOT NULL)
UPDATE Users SET [password] = @password WHERE id=@id
IF (@gender IS NOT NULL)
UPDATE Users SET gender = @gender WHERE id=@id
IF (@email IS NOT NULL)
UPDATE Users SET email = @emaiL WHERE id=@id
IF (@address IS NOT NULL)
UPDATE Users SET address = @address WHERE id=@id
END
ELSE
print 'User not found'
go
--exec availableCourses
--select*from users
--drop proc availableCourses
go
CREATE PROC availableCourses
AS
SELECT Course.* FROM Course LEFT OUTER JOIN StudentTakeCourse ON Course.id = StudentTakeCourse.cid 
LEFT OUTER JOIN Student ON StudentTakeCourse.sid = Student.id
WHERE Course.accepted = '1' AND StudentTakeCourse.sid IS NULL
go

CREATE PROC courseInformation
@id int
AS
IF(EXISTS(SELECT * FROM Course WHERE id = @id))
BEGIN
SELECT Course.*, Users.firstName,Users.lastName FROM Course  INNER JOIN Instructor ON Course.instructorId = Instructor.id 
INNER JOIN Users ON Instructor.id = Users.id
WHERE Course.id = @id
END

go
/*declare @a bit
exec enrollInCourse 2,3,2,@a output */
--Enroll in a course which I had viewed its information.
-- which instructor ??
Create PROC enrollInCourse
@sid INT,
@cid INT,
@instr int,
@existed bit output
AS
BEGIN
if (exists(select * from CoursePrerequisiteCourse where cid=@cid))
begin
if(exists(select * from StudentTakeCourse where sid=@sid and 
cid in (select preid from CoursePrerequisiteCourse where cid=@cid)))
INSERT INTO StudentTakeCourse (sid,cid,insid) VALUES (@sid,@cid,@instr)
else 
print 'Student didnt take this course pre-requisite'
end
else 
begin
if(exists(select * from StudentTakeCourse where sid=@sid and 
cid=@cid and insid=@instr))
set @existed=1
else
begin
set @existed=0
INSERT INTO StudentTakeCourse (sid,cid,insid) VALUES (@sid,@cid,@instr)
end
end
END

go
/*declare @o bit
exec addCreditCard 2 ,'ahmed','a','2/2/2222',1,@o output
print @o*/
--select*from creditcard
go
CREATE PROC addCreditCard
@sid int,
@number varchar(15),
@cardHolderName varchar(16),
@expiryDate datetime,
@cvv varchar(3),
@existedted bit output
AS
IF (EXISTS(SELECT * FROM Users WHERE id=@sid))
BEGIN
IF (EXISTS(SELECT * FROM StudentAddCreditCard s WHERE s.sid=@sid and s.creditCardNumber=@number ))
begin
set @existedted=1
end
else
begin
INSERT INTO CreditCard VALUES (@number,@cardholderName,@expiryDate,@cvv)
insert into StudentAddCreditCard values(@sid,@number)
set @existedted=0
end
END

go 

CREATE PROC viewPromocode
@sid int
AS
SELECT P.* FROM Promocode  P inner join StudentHasPromocode SP on SP.code = P.code 
where SP.sid=@sid
go


CREATE PROC enrollInCourseViewContent
@id int,
@cid int
AS
BEGIN
IF (EXISTS(SELECT * FROM Users WHERE id=@id))
SELECT C.* FROM Course C INNER JOIN StudentTakeCourse STC ON C.id = STC.cid INNER JOIN Student S ON STC.sid = S.id 
INNER JOIN Users Us ON Us.id = S.id
WHERE Us.id = @id and c.id=@cid
ELSE
print 'not a user'
END

go

CREATE PROC viewAssign
@courseId int,
@Sid VARCHAR(10)
AS
BEGIN
IF (EXISTS(SELECT * FROM Users WHERE id=@Sid))
SELECT A.* FROM Assignment A INNER JOIN Course C 
ON A.cid = C.id WHERE C.id = @courseId
ELSE
print 'not a user'
END
go

CREATE PROC submitAssign
@assignType VARCHAR(10),
@assignnumber int,
@sid INT,
@cid INT,
@exists int output
AS
BEGIN
IF (EXISTS(SELECT * FROM StudentTakeCourse WHERE cid = @cid AND sid = @sid ))
BEGIN
INSERT INTO StudentTakeAssignment values (@sid,@cid,@assignnumber,@assignType,null)
set @exists = 1
END
ELSE
set @exists = -1
END
GO
--View the grades of each assignment type.
CREATE PROC viewAssignGrades
@assignnumber int,
@assignType VARCHAR(10),
@cid INT,
@sid INT,
@assignGrade INT OUTPUT
AS
IF(EXISTS(SELECT * FROM StudentTakeAssignment STC INNER JOIN Course C 
ON STC.cid = C.id INNER JOIN Assignment A ON STC.assignmentNumber = A.number 
WHERE STC.cid = @cid AND STC.sid = @sid AND C.id = @cid AND A.[type] = @assignType ))

SELECT @assignGrade = STC.grade FROM StudentTakeAssignment STC  INNER JOIN Course C 
ON STC.cid = C.id INNER JOIN Assignment A ON STC.assignmentNumber = A.number 
WHERE STC.cid = @cid AND STC.sid = @sid AND C.id = @cid AND A.[type] = @assignType 
and A.number=@assignnumber
ELSE
set @assignGrade = -1
GO

--I can add feedback for the course I am enrolled in.
/*
drop proc addFeedback
*/
CREATE PROC addFeedback
@comment VARCHAR(100),
@cid INT,
@sid INT,
@success int output
AS
BEGIN 
IF(dbo.checkStudentEnrolledInCourse(@sid,@cid)='1')
BEGIN
INSERT INTO Feedback (cid,comment,sid) VALUES (@cid,@comment,@sid)
set @success = 1
END
ELSE
set @success = 0
END

GO
Create PROC rateInstructor
@rate DECIMAL (2,1),
@sid INT,
@insid INT
AS
BEGIN
IF(dbo.checkStudentEnrolledInCourse(@sid,@insid)='1')
INSERT INTO StudentRateInstructor (sid,insid,rate) VALUES (@sid,@insid,@rate)
ELSE
print 'student not enrolled in insturctor course'
END


GO
CREATE PROC viewCertificate
@cid INT,
@sid INT

AS
BEGIN
IF (dbo.checkStudentEnrolledInCourse(@sid,@cid)='1' AND EXISTS(SELECT A.fullGrade FROM Assignment A 
INNER JOIN Course C ON A.cid = C.id WHERE C.id= @cid ) )

SELECT SCC.issueDate, C.name, S.firstName, S.lastName FROM StudentCertifyCourse SCC
INNER JOIN Course C ON C.id = SCC.cid
INNER JOIN Users S ON SCC.sid = S.id
WHERE sid = @sid AND cid = @cid


ELSE print 'error'

END
/*
insert into Assignment (cid, number, type, fullGrade) values (3,3,'exam',100)
insert into StudentTakeAssignment (sid,cid,assignmentNumber, assignmenttype, grade) values (2,3,3,'exam',85)
*/
GO

Create PROC viewFinalGrade
@cid INT,
@sid INT,
@finalgrade decimal(10,2) OUTPUT
AS 
BEGIN
IF(dbo.checkStudentEnrolledInCourse(@sid,@cid) = '1' )
SELECT @finalgrade=Grade 
FROM StudentTakeCourse 
where cid=@cid and sid=@sid
END



GO

CREATE PROC payCourse
@cid INT,
@sid INT
AS
BEGIN
IF (EXISTS(SELECT * FROM StudentHasPromoCode WHERE sid = @sid ))
update StudentTakeCourse
set payedfor =1
where  cid = @cid and  sid=@sid

END
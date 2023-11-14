DDl 
create datebase likeappdb;
	1. create table user table:
	create table userstb,
   2. create table posts table
    create table poststb,

   3. create table likes table,
   create table likestb


DML 
1.List all users
Query
..select username from usertb;
Output
username
----------
Edina
Colin
Paula
Glenda
(4 rows)
2.List all posts
Query
..select postcontent from poststb;
Output
postcontent
---------------
Craft
Sale
Design
Tips
Lesson
cartoon
meme
craft
gift
Animal
gold
Awarness
Experimentals
Landsale
Tricks
Forest
Bikesale
Book
Award
Comdey
3.List all post which liked by colin
Query
SELECT poststb.*
FROM poststb
INNER JOIN liketb ON poststb.postid = liketb.postid
INNER JOIN usertb ON liketb.userid = usertb.userid
WHERE usertb.username = 'Colin';
Output
postid | postcontent | postdate | userid
--------+-------------+------------+--------
18 | Book | 2011-07-01 | 4
20 | comdey | 2010-02-20 | 4
14 | Landsale | 2001-06-08 | 3
4 | Tips | 2006-08-19 | 1
6 | cartoon | 2002-03-14 | 2
4. As a glanda she wants to know who are all liked my post
book
Query
SELECT usertb.username
FROM usertb
INNER JOIN liketb ON usertb.userid = liketb.userid
INNER JOIN poststb ON liketb.postid = poststb.postid
WHERE poststb.postcontent = 'Book';
Output
username
----------
Glenda
Paula
Edina
Colin
(4 rows)
5.From Edina need to know the post counts which are liked by
other
Query
SELECT COUNT(DISTINCT poststb.postid)
FROM poststb
INNER JOIN liketb ON poststb.postid = liketb.postid
WHERE poststb.userid = (SELECT userid FROM usertb
WHERE username = 'Edina');
Output
count
-------
2
(1 row)
6.From paula,need to check the count of Awarness and tricks likes counts
 SELECT COUNT(*) AS liked_posts_count
FROM poststb
INNER JOIN likestb ON poststb.postid = likestb.postid
WHERE poststb.userid = (SELECT userid FROM userstb WHERE username = 'Edina');
 liked_posts_count
-------------------
                 5
(1 row)
7.list post of edina which has liked and also not liked posts 
 SELECT poststb.postcontent, COUNT(likestb.likeid) AS like_count
FROM poststb
INNER JOIN likestb ON poststb.postid = likestb.postid
INNER JOIN userstb ON poststb.userid = userstb.userid
WHERE userstb.username = 'Paula' AND poststb.postcontent IN ('Awarness', 'Tricks')
GROUP BY poststb.postcontent;
 postcontent | like_count
-------------+------------
 Awarness    |          2
(1 row)
8. search all users posts with text sal
 SELECT poststb.postid, poststb.postcontent,
      
FROM poststb
LEFT JOIN likestb ON poststb.postid = likestb.postid AND likestb.userid = (SELECT userid FROM userstb WHERE username = 'Edina')
WHERE poststb.userid = (SELECT userid FROM userstb WHERE username = 'Edina');
 postid | postcontent | like_status
--------+-------------+-------------
      2 | Sale        | Not Liked
      5 | Lesson      | Not Liked
      4 | Tips        | Not Liked
      1 | Craft       | Not Liked
      3 | Design      | Not Liked
9.get the count of colin posts 
SELECT userstb.username, poststb.postid, poststb.postcontent
FROM userstb
INNER JOIN poststb ON userstb.userid = poststb.userid
WHERE poststb.postcontent ILIKE '%sal%';
 username | postid | postcontent
----------+--------+-------------
 Edina    |      2 | Sale
 Paula    |     14 | Landsale
 Glenda   |     17 | Bikesale
(3 rows)
10.get count of likes for the post cartoon .user colin
SELECT COUNT(*) AS like_count
FROM likestb l
JOIN poststb p ON l.postid = p.postid
JOIN userstb u ON l.userid = u.userid
WHERE p.postcontent = 'cartoon'
  AND u.username = 'Colin';
 like_count
------------
          1
(1 row)

11.get maximum liked posts
 SELECT p.postid, p.postcontent, COUNT(l.likeid) AS like_count
FROM poststb p
LEFT JOIN likestb l ON p.postid = l.postid
GROUP BY p.postid, p.postcontent
ORDER BY like_count DESC
LIMIT 1;
 postid | postcontent | like_count
--------+-------------+------------
     18 | Book        |          4
(1 row)

12.in edina sort posts by title in forward
SELECT postid, postcontent, postdate, userid
FROM poststb
WHERE userid = (SELECT userid FROM userstb WHERE username = 'Edina')
ORDER BY postcontent ASC;
 postid | postcontent |  postdate  | userid
--------+-------------+------------+--------
      1 | Craft       | 2002-06-18 |      1
      3 | Design      | 2022-01-14 |      1
      5 | Lesson      | 2006-07-19 |      1
      2 | Sale        | 2003-04-10 |      1
      4 | Tips        | 2006-08-19 |      1
(5 rows)
13.in paula sort posts by date backward 
SELECT postid, postcontent, postdate, userid
FROM poststb
WHERE userid = (SELECT userid FROM userstb WHERE username = 'Paula')
ORDER BY postdate DESC;
 postid |  postcontent  |  postdate  | userid
--------+---------------+------------+--------
     11 | gold          | 2024-05-14 |      3
     13 | Experimentals | 2010-06-20 |      3
     15 | Tricks        | 2010-04-07 |      3
     12 | Awarness      | 2006-06-19 |      3
     14 | Landsale      | 2001-06-08 |      3
(5 rows)
 14. filter today posted posts
14.SELECT * FROM poststb
WHERE DATE(postdate) = CURRENT_DATE;
# s_id 学生编号,s_name 学生姓名,s_birth 出生年月,s_sex 学生性别
/**
CREATE TABLE IF NOT EXISTS student (
  s_id VARCHAR (10),
  s_name VARCHAR (10),
  s_birth DATETIME,
  s_sex NVARCHAR (10)
) ;
INSERT INTO student VALUES
('01', '赵雷', '1990-01-01', '男'),
('02', '钱电', '1990-12-21', '男'),
('03', '孙风', '1990-05-20', '男'),
('04', '李云', '1990-08-06', '男'),
('05', '周梅', '1991-12-01', '女'),
('06', '吴兰', '1992-03-01', '女'),
('07', '郑竹', '1989-07-01', '女'),
('08', '王菊', '1990-01-20', '女') ;
 

#c_id 课程编号,c_name 课程名称,t_id 教师编号
CREATE TABLE IF NOT EXISTS course (
  c_id VARCHAR (10),
  c_name VARCHAR (10),
  t_id INT (10)
) ;
INSERT INTO course VALUES
('01', '语文', '02'),
('02', '数学', '01'),
('03', '英语', '03') ;


#t_id 教师编号,t_name 教师姓名
CREATE TABLE IF NOT EXISTS teacher (t_id INT (10), t_name VARCHAR (10)) ;
INSERT INTO teacher VALUES
('01', '张三'),
('02', '李四'),
('03', '王五') ;


#s_id 学生编号,c_id 课程编号,s_score 分数
CREATE TABLE IF NOT EXISTS score (
  s_id VARCHAR (10),
  c_id VARCHAR (10),
  s_score DECIMAL (18, 1)
) ;
INSERT INTO score VALUES
('01', '01', 80),
('01', '02', 90),
('01', '03', 99),
('02', '01', 70),
('02', '02', 60),
('02', '03', 80),
('03', '01', 80),
('03', '02', 80),
('03', '03', 80),
('04', '01', 50),
('04', '02', 30),
('04', '03', 20),
('05', '01', 76),
('05', '02', 87),
('06', '01', 31),
('06', '03', 34),
('07', '02', 89),
('07', '03', 98);
**/



#### 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数  
SELECT a.* , IFNULL(b.s_score,0) score1, IFNULL(c.s_score,0) score2
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id AND b.c_id = '01'
LEFT JOIN score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE IFNULL(b.s_score,0) > IFNULL(c.s_score,0);
################################
SELECT a.* , IFNULL(b.s_score,0) score1, IFNULL(c.s_score,0) score2
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
LEFT JOIN score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE b.c_id = '01' AND IFNULL(b.s_score,0) > IFNULL(c.s_score,0);
################################
SELECT 
  b.*,
  IFNULL(MAX(CASE WHEN a.c_id='01' THEN a.s_score END),0) AS s01,
  IFNULL(MAX(CASE WHEN a.c_id='02' THEN a.s_score END),0) AS s02
FROM score a
RIGHT JOIN student b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING s01 > s02;


#### 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
SELECT a.* , IFNULL(b.s_score,0) score1, IFNULL(c.s_score,0) score2
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id AND b.c_id = '01'
LEFT JOIN score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE IFNULL(b.s_score,0) < IFNULL(c.s_score,0);
################################
SELECT a.* , IFNULL(b.s_score,0) score1, IFNULL(c.s_score,0) score2
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id AND b.c_id = '01'
LEFT JOIN score c ON a.s_id = c.s_id
WHERE c.c_id = '02' AND IFNULL(b.s_score,0) < IFNULL(c.s_score,0);
################################
SELECT 
  b.*,
  IFNULL(MAX(CASE WHEN a.c_id='01' THEN a.s_score END),0) AS s01,
  IFNULL(MAX(CASE WHEN a.c_id='02' THEN a.s_score END),0) AS s02
FROM score a
RIGHT JOIN student b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING s01 < s02;


 
#### 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩   
SELECT a.s_id,a.s_name,ROUND(AVG(b.s_score),2) AS avg_score
FROM student a
JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id,a.s_name
HAVING avg_score >= 60;



#### 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩的和无成绩的)
SELECT a.s_id,a.s_name,ROUND(AVG(b.s_score),2) AS avg_score
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id,a.s_name
HAVING avg_score IS NULL OR avg_score < 60;
################################
SELECT a.s_id,a.s_name,ROUND(AVG(b.s_score),2) AS avg_score
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id,a.s_name
HAVING IFNULL(avg_score,0) < 60;



#### 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
SELECT a.s_id,a.s_name,COUNT(b.s_score) AS course_count,IFNULL(SUM(b.s_score),0) AS sum_score
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id,a.s_name;



#### 6、查询"李"姓老师的数量 
SELECT COUNT(1) FROM teacher WHERE t_name LIKE '李%';



#### 7、查询学过"张三"老师授课的同学的信息 
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id 
JOIN course c ON b.c_id = c.c_id
JOIN teacher d ON c.t_id = d.t_id AND d.t_name = '张三';
################################
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id 
JOIN course c ON b.c_id = c.c_id
JOIN teacher d ON c.t_id = d.t_id 
WHERE d.t_name = '张三';

#### 8、查询没学过"张三"老师授课的同学的信息 
SELECT * FROM student WHERE s_id NOT IN
(
SELECT a.s_id FROM student a
JOIN score b ON a.s_id = b.s_id 
JOIN course c ON b.c_id = c.c_id
JOIN teacher d ON c.t_id = d.t_id AND d.t_name = '张三'
);
##############
SELECT student.* FROM student
LEFT JOIN 
(
SELECT s_id FROM score
JOIN  course ON course.c_id = score.c_id
JOIN  teacher ON course.t_id = teacher.t_id AND t_name = '张三'
)tmp
ON  student.s_id = tmp.s_id
WHERE tmp.s_id IS NULL;



#### 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id AND b.c_id = '01'
JOIN score c ON a.s_id = c.s_id AND c.c_id = '02';
################
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id
JOIN score c ON a.s_id = c.s_id
WHERE b.c_id = '01' AND c.c_id = '02';
################
SELECT a.* FROM student a
WHERE a.s_id IN(SELECT b.s_id FROM score b WHERE b.c_id = '01')
AND a.s_id IN(SELECT c.s_id FROM score c WHERE c.c_id = '02');


 
#### 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id AND b.c_id = '01'
LEFT JOIN score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE c.s_score IS NULL;
################
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id
LEFT JOIN score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE b.c_id = '01' AND c.s_score IS NULL;
################
SELECT a.* FROM student a
WHERE a.s_id IN(SELECT b.s_id FROM score b WHERE b.c_id = '01')
AND a.s_id NOT IN(SELECT c.s_id FROM score c WHERE c.c_id = '02');
################
SELECT 
  b.*,
  MAX(CASE WHEN a.c_id = '01' THEN s_score END) AS s01,
  MAX(CASE WHEN a.c_id = '02' THEN s_score END) AS s02
FROM score a
RIGHT JOIN student b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING s01 IS NOT NULL AND s02 IS NULL;
################
SELECT
  a.*,b.s01,b.s02
FROM student a
JOIN(
  SELECT 
    s_id,
    MAX(CASE WHEN c_id = '01' THEN s_score END) AS s01,
    MAX(CASE WHEN c_id = '02' THEN s_score END) AS s02
  FROM score
  GROUP BY s_id
  HAVING s01 IS NOT NULL AND s02 IS NULL
  )b
ON a.s_id = b.s_id;



#### 11、查询没有学全所有课程的同学的信息
SELECT a.*,COUNT(b.c_id) AS cnt
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING cnt < (SELECT COUNT(c_id) FROM course);
 
 
 
#### 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
SELECT a.* FROM student a
JOIN (SELECT c_id FROM score WHERE s_id = '01') b
JOIN score c ON a.s_id = c.s_id
WHERE a.s_id != '01' AND b.c_id = c.c_id
GROUP BY a.s_id,a.s_name,a.s_birth,a.s_sex;
############################
SELECT a.*
FROM student a
JOIN score b ON a.s_id = b.s_id
WHERE b.c_id IN (SELECT c_id FROM score WHERE s_id = '01')
AND a.s_id != '01'
GROUP BY a.s_id;


#### 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息 
SELECT * FROM student
WHERE s_id != '01' AND s_id NOT IN 
(
  SELECT s_id FROM
  (
    SELECT a.s_id,b.c_id,c.c_id AS c_id2
    FROM student a
    JOIN (SELECT c_id FROM score WHERE s_id = '01')b
    LEFT JOIN score c ON a.s_id = c.s_id AND b.c_id = c.c_id

    UNION

    SELECT a.s_id,b.c_id,c.c_id AS c_id2
    FROM student a
    JOIN (SELECT c_id FROM score WHERE s_id = '01')b
    RIGHT JOIN score c ON a.s_id = c.s_id AND b.c_id = c.c_id
  )t
  WHERE c_id IS NULL OR c_id2 IS NULL
);
######################################################################################
WITH cte AS
(
  SELECT a.s_id,b.c_id,c.c_id AS c_id2
  FROM student a
  JOIN (SELECT c_id FROM score WHERE s_id = '01')b
  LEFT JOIN score c ON a.s_id = c.s_id AND b.c_id = c.c_id

  UNION

  SELECT a.s_id,b.c_id,c.c_id AS c_id2
  FROM student a
  JOIN (SELECT c_id FROM score WHERE s_id = '01')b
  RIGHT JOIN score c ON a.s_id = c.s_id AND b.c_id = c.c_id
)
SELECT * FROM student
WHERE s_id != '01' AND s_id NOT IN (SELECT s_id FROM cte WHERE c_id IS NULL OR c_id2 IS NULL);
######################################################################################
SELECT a.* FROM student a
JOIN score b ON a.s_id = b.s_id
WHERE a.s_id != '01'
GROUP BY a.s_id 
HAVING GROUP_CONCAT(b.c_id ORDER BY b.c_id) = (SELECT GROUP_CONCAT(c_id ORDER BY c_id) FROM score WHERE s_id = '01');



#### 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
SELECT a.* 
FROM student a
LEFT JOIN (
  SELECT s_id FROM score WHERE c_id IN (SELECT c_id FROM course WHERE t_id = (SELECT t_id FROM teacher WHERE t_name = '张三'))
)b
ON a.s_id = b.s_id
WHERE b.s_id IS NULL;
#############################
SELECT a.* 
FROM student a
LEFT JOIN (
  SELECT s_id FROM score c
  JOIN course d ON c.c_id = d.c_id
  JOIN teacher e ON d.t_id = e.t_id 
  WHERE e.t_name = "张三"
)b
ON a.s_id = b.s_id
WHERE b.s_id IS NULL;



#### 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
SELECT a.s_id,a.s_name,c.avg_score 
FROM student a
JOIN (
  SELECT s_id 
  FROM score 
  WHERE s_score < 60
  GROUP BY s_id
  HAVING COUNT(1) >= 2
)b
ON a.s_id = b.s_id
LEFT JOIN(
  SELECT s_id,AVG(s_score) avg_score
  FROM score 
  GROUP BY s_id
)c
ON a.s_id = c.s_id;
############################
SELECT a.s_id,a.s_name,AVG(b.s_score) AS avg_score
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING SUM(CASE WHEN b.s_score < 60 THEN 1 ELSE 0 END) >= 2;



#### 16、检索"01"课程分数小于60，按分数降序排列的学生信息
SELECT a.*,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id AND b.c_id = '01' AND b.s_score < 60
ORDER BY b.s_score DESC;
############################
SELECT a.*,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id 
WHERE b.c_id = '01' AND b.s_score < 60
ORDER BY b.s_score DESC;



#### 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
SELECT a.s_id,a.s_name,c.c_name,b.s_score,AVG(b.s_score) over(PARTITION BY a.s_id) avg_score 
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
JOIN course c ON b.c_id = c.c_id
ORDER BY avg_score DESC;
####################
SELECT 
  a.s_id,
  a.s_name,
  MAX(CASE WHEN c.c_name = '语文' THEN b.s_score END) as '语文',
  MAX(CASE WHEN c.c_name = '数学' THEN b.s_score END) as '数学',
  MAX(CASE WHEN c.c_name = '英语' THEN b.s_score END) as '英语',
  AVG(b.s_score) AS avg_score 
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
JOIN course c ON b.c_id = c.c_id
GROUP BY a.s_id,a.s_name
ORDER BY avg_score DESC;
####################
SELECT a.s_id,tmp1.s_score AS chinese,tmp2.s_score AS math,tmp3.s_score AS english,
    ROUND(AVG (a.s_score),2) AS avgScore
FROM score a
LEFT JOIN (SELECT s_id,s_score FROM score s1 WHERE c_id='01')tmp1 ON tmp1.s_id=a.s_id
LEFT JOIN (SELECT s_id,s_score FROM score s2 WHERE c_id='02')tmp2 ON tmp2.s_id=a.s_id
LEFT JOIN (SELECT s_id,s_score FROM score s3 WHERE c_id='03')tmp3 ON tmp3.s_id=a.s_id
GROUP BY a.s_id,tmp1.s_score,tmp2.s_score,tmp3.s_score ORDER BY avgScore DESC;
####################
SELECT
 st.*,
 GROUP_CONCAT(c.c_name) 课程,
 GROUP_CONCAT(sc.s_score) 分数,
 AVG(sc.s_score) 平均分 
FROM student st 
LEFT JOIN score sc ON st.s_id=sc.s_id 
JOIN course c ON sc.c_id=c.c_id 
GROUP BY sc.s_id ORDER BY AVG(sc.s_score) DESC;



#### 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率.及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
SELECT 
  b.c_id AS 课程ID,
  b.c_name AS 课程name,
  MAX(a.s_score) AS 最高分,
  MIN(a.s_score) AS 最低分,
  AVG(a.s_score) AS 平均分,
  SUM(CASE WHEN a.s_score >= 60 THEN 1 ELSE 0 END)/COUNT(1) AS 及格率,
  SUM(CASE WHEN a.s_score >= 70 AND a.s_score < 80 THEN 1 ELSE 0 END)/COUNT(1) AS 中等率,
  SUM(CASE WHEN a.s_score >= 80 AND a.s_score < 90 THEN 1 ELSE 0 END)/COUNT(1) AS 优良率,
  SUM(CASE WHEN a.s_score >= 90 THEN 1 ELSE 0 END)/COUNT(1) AS 优秀率
FROM score a
JOIN course b ON a.c_id = b.c_id
GROUP BY a.c_id;
      
#### 19、按各科成绩进行排序，并显示排名
SELECT 
  a.*,
  (SELECT COUNT(b.s_score) FROM score b WHERE a.c_id = b.c_id AND a.s_score < b.s_score) + 1 AS rk,
  (SELECT COUNT(DISTINCT b.s_score) FROM score b WHERE a.c_id = b.c_id AND a.s_score <= b.s_score) AS dense_rk,
  @row:=(CASE WHEN @p=a.c_id AND @p:=a.c_id THEN @row + 1 ELSE 1 AND @p:=a.c_id END) AS row_num
FROM score a,(SELECT @p:=null,@row:=0)b
ORDER BY a.c_id,a.s_score DESC;
####################################
SELECT s_id,c_id,s_score,rk,dense_rk,row_num
FROM
  (
  SELECT 
    a.*,
    @r:=(CASE WHEN @c=a.c_id THEN IF(@s=a.s_score,@r,@row+1) ELSE 1 END) AS rk,
    @dr:=(CASE WHEN @c=a.c_id THEN IF(@s>a.s_score,@dr+1,@dr) ELSE 1 END) AS dense_rk,
    @row:=(CASE WHEN @c=a.c_id THEN @row+1 ELSE 1 END) AS row_num,
    @c:=a.c_id,
    @s:=a.s_score
  FROM score a,(SELECT @r:=0,@dr:=0,@row:=0,@c:=NULL,@s:=NULL) t
  ORDER BY a.c_id,a.s_score DESC
)t;
####################################
SELECT 
  a.*,
  @r:=(CASE WHEN @c=a.c_id THEN IF(@s=a.s_score,@r,@row+1) ELSE 1 END) AS rk,
  @dr:=(CASE WHEN @c=a.c_id THEN IF(@s>a.s_score,@dr+1,@dr) ELSE 1 END) AS dense_rk,
  @row:=(CASE WHEN (@s:=a.s_score) AND @c=a.c_id AND @c:=a.c_id THEN @row+1 ELSE 1 AND @c:=a.c_id END) AS row_num
FROM score a,(SELECT @r:=0, @dr:=0, @row:=0, @c:=NULL, @s:=NULL) t
ORDER BY a.c_id,a.s_score DESC;
####################################
SELECT 
  a.*,
  RANK() over w AS rk,
  DENSE_RANK() over w AS dense_rk,
  ROW_NUMBER() over w AS row_num
FROM score a
WINDOW w AS (PARTITION BY a.c_id ORDER BY a.s_score DESC)
ORDER BY a.c_id,a.s_score DESC;



#### 20、查询学生的总成绩并进行排名
SELECT 
  a.s_id,
  a.s_name,
  SUM(b.s_score) AS total_score,
  RANK() OVER  w AS 'rank',
  DENSE_RANK() OVER  w AS 'dense_rank',
  ROW_NUMBER() OVER  w AS 'row_number'
FROM student a
JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id
WINDOW w AS (ORDER BY SUM(b.s_score) DESC)
ORDER BY total_score DESC;
###########################
SELECT 
  t.*,
  RANK() OVER  w AS 'rank',
  DENSE_RANK() OVER  w AS 'dense_rank',
  ROW_NUMBER() OVER  w AS 'row_number'
FROM
  (SELECT 
    a.s_id,
    a.s_name,
    SUM(b.s_score) AS total_score
  FROM student a
  JOIN score b ON a.s_id = b.s_id
  GROUP BY a.s_id)t
WINDOW w AS (ORDER BY t.total_score DESC)
ORDER BY t.total_score DESC;



#### 21、查询不同老师所教不同课程平均分从高到低显示 
SELECT 
  a.t_name,
  b.c_name,
  AVG(c.s_score) AS avg_score
FROM teacher a
JOIN course b ON a.t_id = b.t_id
JOIN score c ON b.c_id = c.c_id
GROUP BY a.t_id,b.c_id
ORDER BY avg_score DESC;



#### 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
SELECT a.*,b.c_id,b.s_score,b.rank
FROM student a
JOIN
  (
  SELECT score.*,IF(@p=c_id,@r:=@r+1,@r:=1) AS 'rank',@p:=c_id
  FROM score
  JOIN (SELECT @p:=NULL,@r:=0)t
  ORDER BY c_id,s_score DESC
  )b
ON a.s_id = b.s_id
WHERE b.rank BETWEEN 2 AND 3
ORDER BY b.c_id,b.rank;
#######################################################
SELECT *
FROM
  (
  SELECT a.*,b.c_id,b.s_score,rank() over w AS 'rank'
  FROM student a
  RIGHT JOIN score b
  ON a.s_id = b.s_id
  WINDOW w AS (PARTITION BY c_id ORDER BY b.c_id,b.s_score DESC,a.s_id)
  ORDER BY b.c_id,'rank'
)t
WHERE t.rank BETWEEN 2 AND 3;


 
#### 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
SELECT 
  t.c_id,
  t.c_name,
  a.count_85_100,
  a.percent_85_100,
  b.count_70_85,
  b.percent_70_85,
  c.count_60_70,
  c.percent_60_70,
  d.count_0_60,
  d.percent_0_60
FROM course t
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) AS count_85_100,
        SUM(CASE WHEN s_score BETWEEN 85 AND 100 THEN 1 ELSE 0 END)/COUNT(c_id) AS percent_85_100
      FROM score 
      GROUP BY c_id
      ) AS a 
ON t.c_id = a.c_id
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score BETWEEN 70 AND 85 THEN 1 ELSE 0 END) AS count_70_85,
        SUM(CASE WHEN s_score BETWEEN 70 AND 85 THEN 1 ELSE 0 END)/COUNT(c_id) AS percent_70_85
      FROM score 
      GROUP BY c_id
      ) AS b 
ON t.c_id = b.c_id
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score BETWEEN 60 AND 70 THEN 1 ELSE 0 END) AS count_60_70,
        SUM(CASE WHEN s_score BETWEEN 60 AND 70 THEN 1 ELSE 0 END)/COUNT(c_id) AS percent_60_70
      FROM score 
      GROUP BY c_id
      ) AS c 
ON t.c_id = c.c_id
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score <= 60 THEN 1 ELSE 0 END) AS count_0_60,
        SUM(CASE WHEN s_score <= 60 THEN 1 ELSE 0 END)/COUNT(c_id) AS percent_0_60
      FROM score 
      GROUP BY c_id
      ) AS d 
ON t.c_id = d.c_id;
######################
SELECT 
  t.c_id,
  t.c_name,
  a.count_85_100,
  a.count_85_100/a.total_85_100 AS percent_85_100,
  b.count_70_85,
  b.count_70_85/b.total_70_85 AS percent_70_85,
  c.count_60_70,
  c.count_60_70/c.total_60_70 AS percent_60_70,
  d.count_0_60,
  d.count_0_60/d.total_0_60 AS percent_0_60
FROM course t
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) AS count_85_100,
        COUNT(c_id) AS total_85_100 
      FROM score 
      GROUP BY c_id
      ) AS a 
ON t.c_id = a.c_id
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score BETWEEN 70 AND 85 THEN 1 ELSE 0 END) AS count_70_85,
        COUNT(c_id) AS total_70_85
      FROM score 
      GROUP BY c_id
      ) AS b 
ON t.c_id = b.c_id
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score BETWEEN 60 AND 70 THEN 1 ELSE 0 END) AS count_60_70,
        COUNT(c_id) AS total_60_70
      FROM score 
      GROUP BY c_id
      ) AS c 
ON t.c_id = c.c_id
JOIN (
      SELECT 
        c_id,
        SUM(CASE WHEN s_score <= 60 THEN 1 ELSE 0 END) AS count_0_60,
        COUNT(c_id) AS total_0_60
      FROM score 
      GROUP BY c_id
      ) AS d 
ON t.c_id = d.c_id;
######################
SELECT 
  c_id,
  c_name,
  count_85_100,
  count_85_100/total AS percent_85_100,
  count_70_85,
  count_70_85/total AS percent_70_85,
  count_60_70,
  count_60_70/total AS percent_60_70,
  count_0_60,
  count_0_60/total AS percent_0_60
FROM(
  SELECT 
    a.c_id,
    a.c_name,
    SUM(CASE WHEN b.s_score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) over w AS count_85_100,
    SUM(CASE WHEN b.s_score BETWEEN 70 AND 85 THEN 1 ELSE 0 END) over w AS count_70_85,
    SUM(CASE WHEN b.s_score BETWEEN 60 AND 70 THEN 1 ELSE 0 END) over w AS count_60_70,
    SUM(CASE WHEN b.s_score <= 60 THEN 1 ELSE 0 END) over w AS count_0_60,
    COUNT(b.c_id) over w AS total
  FROM course a
  JOIN score b
  ON a.c_id = b.c_id
  WINDOW w AS (PARTITION BY a.c_id)
)t
GROUP BY c_id;
######################
SELECT 
  a.c_id,
  a.c_name,
  SUM(CASE WHEN b.s_score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) AS '[100-85]',
  SUM(CASE WHEN b.s_score BETWEEN 70 AND 85 THEN 1 ELSE 0 END) AS '[85-70]',
  SUM(CASE WHEN b.s_score BETWEEN 60 AND 70 THEN 1 ELSE 0 END) AS '[70-60]',
  SUM(CASE WHEN b.s_score <= 60 THEN 1 ELSE 0 END) AS '[0-60]',
  SUM(CASE WHEN b.s_score BETWEEN 85 AND 100 THEN 1 ELSE 0 END)/COUNT(1) AS '[100-85]%',
  SUM(CASE WHEN b.s_score BETWEEN 70 AND 85 THEN 1 ELSE 0 END)/COUNT(1) AS '[85-70]%',
  SUM(CASE WHEN b.s_score BETWEEN 60 AND 70 THEN 1 ELSE 0 END)/COUNT(1) AS '[70-60]%',
  SUM(CASE WHEN b.s_score <= 60 THEN 1 ELSE 0 END)/COUNT(1) AS '[0-60]%'
FROM course a
JOIN score b
ON a.c_id = b.c_id
GROUP BY a.c_id,a.c_name;



#### 24、查询学生平均成绩及其名次 
SELECT a.s_id,b.s_name,AVG(a.s_score) AS avg_score,rank() over w AS 'rank'
FROM score a
JOIN student b ON a.s_id = b.s_id
GROUP BY a.s_id
WINDOW w AS (ORDER BY AVG(a.s_score) DESC)
ORDER BY avg_score DESC;
######################
SELECT tmp.*,row_number()over(ORDER BY tmp.avgScore DESC) Ranking FROM
  (SELECT student.s_id,
          student.s_name,
          ROUND(AVG(score.s_score),2) AS avgScore
  FROM student JOIN score
  ON student.s_id=score.s_id
  GROUP BY student.s_id,student.s_name)tmp
ORDER BY avgScore DESC;



#### 25、查询各科成绩前三名的记录
SELECT * FROM
(
  SELECT *,rank() over(PARTITION BY c_id ORDER BY s_score DESC) AS 'rank'
  FROM score 
  ORDER BY c_id,s_score DESC
)t
WHERE t.rank <= 3;



#### 26、查询每门课程被选修的学生数 
SELECT a.c_id,a.c_name,COUNT(s_id) AS cnt
FROM course a
LEFT JOIN score b ON a.c_id = b.c_id
GROUP BY a.c_id;



#### 27、查询出只有两门课程的全部学生的学号和姓名 
EXPLAIN
SELECT a.*
FROM student a
JOIN score b
ON a.s_id = b.s_id
GROUP BY s_id
HAVING COUNT(b.c_id) = 2 ;
######################################
SELECT st.s_id,st.s_name 
FROM student st
JOIN (SELECT s_id FROM score GROUP BY s_id HAVING COUNT(c_id) =2)tmp
ON st.s_id=tmp.s_id;



#### 28、查询男生、女生人数 
SELECT s_sex,COUNT(1) AS s_count FROM student GROUP BY s_sex;
######################################
SELECT tmp1.man,tmp2.women FROM
(SELECT COUNT(1) AS man FROM student WHERE s_sex='男')tmp1,
(SELECT COUNT(1) AS women FROM student WHERE s_sex='女')tmp2;



#### 29、查询名字中含有"风"字的学生信息
SELECT * FROM student WHERE s_name LIKE '%风%';



#### 30、查询同名同性学生名单，并统计同名人数 
SELECT s1.s_id,s1.s_name,s1.s_sex,COUNT(*) AS sameName
FROM student s1,student s2
WHERE s1.s_name = s2.s_name AND s1.s_id <> s2.s_id AND s1.s_sex = s2.s_sex
GROUP BY s1.s_id,s1.s_name,s1.s_sex;
#########################
SELECT s_id,s_name,s_sex,COUNT(s_name) AS cnt 
FROM student
GROUP BY s_name,s_sex
HAVING cnt > 1;
 
#### 31、查询1990年出生的学生名单
SELECT * FROM student WHERE EXTRACT(YEAR FROM s_birth) = '1990';
#########################
SELECT * FROM student WHERE YEAR(s_birth) = 1990;

 
#### 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 
SELECT c_id,AVG(s_score) AS avg_score
FROM score 
GROUP BY c_id
ORDER BY avg_score DESC,c_id ASC;


 
#### 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 
SELECT a.s_id,a.s_name,AVG(b.s_score) AS avg_score
FROM student a
JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING IFNULL(avg_score,0) >= 85;



#### 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 
SELECT a.s_name,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id AND b.s_score < 60
JOIN course c ON b.c_id = c.c_id AND c.c_name = '数学'
GROUP BY a.s_id;
############################
SELECT a.s_name,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id
JOIN course c ON b.c_id = c.c_id
WHERE c.c_name = '数学' AND b.s_score < 60
GROUP BY a.s_id;


#### 35、查询所有学生的课程及分数情况； 
SELECT a.s_id,a.s_name,c.c_name,b.s_score
FROM student a
LEFT JOIN score b ON a.s_id = b.s_id
LEFT JOIN course c ON b.c_id = c.c_id;



#### 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数；
SELECT a.s_id,a.s_name,c.c_name,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id AND b.s_score >= 70
JOIN course c ON b.c_id = c.c_id
GROUP BY a.s_id;
#################################
SELECT a.s_id,a.s_name,c.c_name,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id
JOIN course c ON b.c_id = c.c_id
WHERE b.s_score >= 70
GROUP BY a.s_id;



#### 37、查询不及格的课程
SELECT a.s_name,c.c_name,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id AND b.s_score < 60
JOIN course c ON b.c_id = c.c_id
GROUP BY a.s_name,c.c_name;



#### 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名； 
SELECT a.s_id,a.s_name,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id
WHERE b.c_id = '01' AND b.s_score >= 80;

#### 39、求每门课程的学生人数 
SELECT a.c_id,a.c_name,COUNT(b.s_id) AS num
FROM course a
JOIN score b ON a.c_id = b.c_id
GROUP BY a.c_id,a.c_name;



#### 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩
EXPLAIN
SELECT a.*,b.s_score
FROM student a
JOIN score b ON a.s_id = b.s_id
JOIN course c ON b.c_id = c.c_id
JOIN teacher d ON c.t_id = d.t_id AND d.t_name = '张三'
ORDER BY b.s_score DESC
LIMIT 1;
##################################
SELECT student.*,tmp3.c_name,tmp3.maxScore
FROM (
  SELECT s_id,c_name,MAX(s_score)AS maxScore 
  FROM score
  JOIN (SELECT course.c_id,c_name 
        FROM course 
        JOIN (SELECT t_id,t_name FROM teacher WHERE t_name = '张三')tmp
        ON course.t_id=tmp.t_id)tmp2
  ON score.c_id = tmp2.c_id 
  GROUP BY score.s_id,c_name
  ORDER BY maxScore DESC LIMIT 1
  )tmp3
JOIN student
ON student.s_id=tmp3.s_id;
##################################
SELECT student.*,tmp3.c_name,tmp3.maxScore
FROM (SELECT s_id,c_name,MAX(s_score) AS maxScore 
      FROM score
      JOIN (SELECT course.c_id,c_name FROM course WHERE course.t_id = (SELECT t_id FROM teacher WHERE t_name = '张三'))tmp2
      ON score.c_id = tmp2.c_id 
      GROUP BY score.s_id,c_name
      ORDER BY maxScore DESC LIMIT 1)tmp3
JOIN student
ON student.s_id=tmp3.s_id;



#### 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
SELECT DISTINCT a.s_id,a.c_id,a.s_score 
FROM score a,score b
WHERE a.c_id <> b.c_id AND a.s_score=b.s_score;



#### 42、查询每门功成绩最好的前两名 
SELECT a.c_id,a.c_name,c.s_id,c.s_name,b.s_score,b.row_rank
FROM course a
JOIN (SELECT c_id,s_id,s_score,ROW_NUMBER() over(PARTITION BY c_id ORDER BY s_score DESC) AS row_rank
      FROM score
      ORDER BY c_id,row_rank) b 
ON a.c_id = b.c_id AND b.row_rank <= 3
JOIN student c 
ON b.s_id = c.s_id
ORDER BY a.c_id;


  
#### 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列 
SELECT a.c_id,a.c_name,COUNT(b.s_id) AS st_count 
FROM course a
JOIN score b ON a.c_id = b.c_id
GROUP BY a.c_id
HAVING st_count >= 5
ORDER BY st_count DESC,a.c_id ASC;



#### 44、检索至少选修两门课程的学生学号 
SELECT a.s_id,a.s_name,COUNT(b.c_id) AS course_count
FROM student a
JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING COUNT(b.c_id) >= 2;



#### 45、查询选修了全部课程的学生信息 
EXPLAIN
SELECT a.*
FROM student a
JOIN score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING COUNT(b.c_id) = (SELECT COUNT(1) FROM course);



#### 46、查询各学生的年龄
SELECT *,
  (YEAR(CURRENT_DATE) - YEAR(s_birth) - 
    (CASE 
       WHEN MONTH(CURRENT_DATE) < MONTH(s_birth) 
	   THEN 1
       WHEN MONTH(CURRENT_DATE) = MONTH(s_birth) AND DAY(CURRENT_DATE) < DAY(s_birth) 
       THEN 1
       ELSE 0 
     END)
  ) AS age
FROM student;



#### 47、查询本周过生日的学生
SELECT * FROM student WHERE WEEKOFYEAR(CURRENT_DATE) = WEEKOFYEAR(s_birth);


#### 48、查询下周过生日的学生
SELECT * FROM student WHERE WEEKOFYEAR(CURRENT_DATE) + 1 = WEEKOFYEAR(s_birth);



#### 49、查询本月过生日的学生
SELECT * FROM student WHERE MONTH(CURRENT_DATE) = MONTH(s_birth);



#### 50、查询下月过生日的学生
SELECT * FROM student WHERE MONTH(CURRENT_DATE) + 1 = MONTH(s_birth);


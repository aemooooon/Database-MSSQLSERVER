-- Question 1
SELECT TOP 1 WITH TIES
    title, price
FROM titles
WHERE price IS NOT NULL
ORDER BY price

-- Question 2
SELECT t.title
FROM titles t JOIN sales s ON t.title_id=s.title_id
WHERE qty>40

-- Question 3
SELECT au_id, au_lname, au_fname
FROM authors
WHERE au_id NOT IN (SELECT au_id
FROM titleauthor)

-- Question 4
SELECT DISTINCT p.pub_name
FROM publishers p JOIN titles t ON p.pub_id=t.pub_id
WHERE t.type='business'
ORDER BY p.pub_name DESC

-- Question 5
SELECT a.au_lname, a.au_fname
From titles t JOIN titleauthor ta ON t.title_id=ta.title_id JOIN authors a ON ta.au_id=a.au_id
WHERE t.type='popular_comp'

-- Question 6
SELECT city
FROM publishers
WHERE city IN (
SELECT a.city
From titles t JOIN titleauthor ta ON t.title_id=ta.title_id JOIN authors a ON ta.au_id=a.au_id)

-- Question 7
SELECT DISTINCT city
FROM authors
WHERE city NOT IN (SELECT city
FROM publishers)
ORDER BY city

-- Question 8
SELECT title
FROM titles
WHERE title_id NOT IN (SELECT title_id
FROM sales
WHERE qty>0)

-- Question 9
SELECT t.title, SUM(s.qty)
FROM titles t JOIN sales s ON t.title_id=s.title_id
GROUP BY t.title
HAVING SUM(s.qty)<
(SELECT SUM(s.qty)/(SELECT COUNT(r.title_id) as totalAvg
    FROM (SELECT DISTINCT title_id
        FROM sales) AS r)
FROM sales s)
ORDER BY t.title

-- Question 10
SELECT p.pub_name, COUNT(t.title_id)
FROM publishers p JOIN titles t ON p.pub_id=t.pub_id
WHERE p.state!='CA'
GROUP BY p.pub_name

-- Question 11
SELECT t.title, COUNT(ss.stor_id)
FROM titles t JOIN sales s ON t.title_id=s.title_id JOIN stores ss ON s.stor_id=ss.stor_id
WHERE s.qty>0
GROUP BY t.title
ORDER BY t.title

-- Question 12
SELECT t.title, ss.stor_name, MAX(s.qty)
FROM titles t JOIN sales s ON t.title_id=s.title_id JOIN stores ss ON s.stor_id=ss.stor_id
GROUP BY t.title,ss.stor_name
ORDER BY t.title

-- Question 13
UPDATE roysched SET royalty=royalty+2 WHERE title_id IN (SELECT t.title_id
FROM titles t JOIN sales s ON t.title_id=s.title_id
GROUP BY t.title_id
HAVING SUM(s.qty)>30)

-- Question 14
SELECT r.type
FROM (SELECT DISTINCT t.type, t.pub_id
    FROM titles t) AS r
GROUP BY r.type
HAVING COUNT(r.type)>1

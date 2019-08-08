-- Question 1
SELECT TOP 1 WITH TIES title,price FROM titles WHERE price IS NOT NULL ORDER BY price

-- Question 2
SELECT t.title FROM titles t JOIN sales s ON t.title_id=s.title_id WHERE qty>40

-- Question 3
SELECT au_id,au_lname,au_fname FROM authors WHERE au_id NOT IN (SELECT au_id FROM titleauthor)

-- Question 4
SELECT DISTINCT p.pub_name FROM publishers p JOIN titles t ON p.pub_id=t.pub_id WHERE t.type='business' ORDER BY p.pub_name DESC

-- Question 5
SELECT a.au_lname,a.au_fname From titles t JOIN titleauthor ta ON t.title_id=ta.title_id JOIN authors a ON ta.au_id=a.au_id WHERE t.type='popular_comp'

-- Question 6
SELECT city FROM publishers WHERE city IN (
SELECT a.city From titles t JOIN titleauthor ta ON t.title_id=ta.title_id JOIN authors a ON ta.au_id=a.au_id)

-- Question 7

-- Question 8


-- Question 9


-- Question 10


-- Question 11


-- Question 12


-- Question 13


-- Question 14










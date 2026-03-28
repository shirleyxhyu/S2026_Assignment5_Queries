# Q1: How many containers of antibiotics are currently available?
SELECT quantityOnHand 
FROM item
WHERE itemDescription = 'bottle of antibiotics';

# Q2: Which volunteer(s), if any, have phone numbers that do not start with the number 2 and whose last name is not Jones. Query should retrieve names rather than ids.
SELECT volunteerName 
FROM volunteer
WHERE volunteerTelephone IS NOT NULL
AND volunteerTelephone NOT LIKE '2%'
AND volunteerName NOT LIKE '%Jones';

# Q3: Which volunteer(s) are working on transporting tasks? Query should retrieve names rather than ids.
SELECT DISTINCT volunteer 
FROM volunteertask
WHERE taskType = 'transporting';

# Q4: Which task(s) have yet to be assigned to any volunteers (provide task descriptions, not the codes)?
SELECT t.taskDescription 
FROM task AS t
LEFT JOIN assignment AS a
ON t.taskCode = a.taskCode
WHERE a.volunteerId IS NULL;

# Q5: Which type(s) of package contain some kind of bottle?
SELECT DISTINCT tp.packageType
FROM taskpackage AS tp
JOIN package_contents AS pc
ON tp.package = pc.packageId
JOIN item AS i
ON pc.itemId = i.itemId
WHERE i.itemDescription LIKE '%bottle%';

# Q6: Which items, if any, are not in any packages? Answer should be item descriptions.
SELECT itemDescription
FROM item
WHERE itemId NOT IN (
    SELECT itemId
    FROM package_contents
);

# Q7: Which task(s) are assigned to volunteer(s) that live in New Jersey (NJ)? Answer should have the task description and not the task ids.
SELECT DISTINCT t.taskDescription
FROM task AS t
JOIN assignment AS a
ON t.taskCode = a.taskCode
JOIN volunteer AS v
ON a.volunteerId = v.volunteerId
WHERE v.volunteerAddress LIKE '%NJ%';

# Q8: Which volunteers began their assignments in the first half of 2021? Answer should have the volunteer names and not their ids.
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a
ON v.volunteerId = a.volunteerId
WHERE a.startDateTime >= '2021-01-01'
AND a.startDateTime < '2021-07-01';

# Q9: Which volunteers have been assigned to tasks that include packing spam? Answer should have the volunteer names and not their ids.
SELECT DISTINCT vt.volunteer
FROM volunteertask AS vt
JOIN taskpackage AS tp
ON vt.task = tp.task
JOIN package_contents AS pc
ON tp.package = pc.packageId
JOIN item AS i
ON pc.itemId = i.itemId
WHERE i.itemDescription = 'can of spam';

# Q10: Which item(s) (if any) have a total value of exactly $100 in one package? Answer should be item descriptions.
SELECT DISTINCT i.itemDescription
FROM item AS i
JOIN package_contents AS pc
ON i.itemId = pc.itemId
WHERE i.itemValue * pc.itemQuantity = 100;

# Q11: How many volunteers are assigned to tasks with each different status? The answer should show each different status and the number of volunteers sorted from highest to lowest)
SELECT taskStatus, COUNT(DISTINCT volunteer) AS numVolunteer
FROM volunteertask
WHERE taskStatus IS NOT NULL
GROUP BY taskStatus
ORDER BY numVolunteer DESC;

# Q12: Which task creates the heaviest set of packages and what is the weight? Show both the taskCode and the weight (You should be able to do this without using any sub-queries).
SELECT taskCode, SUM(packageWeight) AS totalWeight
FROM package
GROUP BY taskCode
ORDER BY totalWeight DESC
LIMIT 1;

# Q13: How many tasks are there that do not have a type of “packing”?
SELECT COUNT(DISTINCT task) AS numTask
FROM taskpackage
WHERE taskType <> 'packing';

# Q14: Of those items that have been packed, which item (or items) were touched by fewer than 3 volunteers? Answer should be item descriptions.
SELECT i.itemDescription
FROM item AS i
JOIN package_contents AS pc
ON i.itemId = pc.itemId
JOIN package AS p
ON pc.packageId = p.packageId
JOIN assignment AS a
ON p.taskCode = a.taskCode
GROUP BY i.itemId, i.itemDescription
HAVING COUNT(DISTINCT a.volunteerId) < 3;

# Q15: Which packages have a total value of more than 100? Show the packageIds and their value sorted from lowest to highest.
SELECT pc.packageId, SUM(i.itemValue * pc.itemQuantity) AS packageValue
FROM package_contents AS pc
JOIN item AS i
ON pc.itemId = i.itemId
GROUP BY pc.packageId
HAVING SUM(i.itemValue * pc.itemQuantity) > 100
ORDER BY packageValue ASC;

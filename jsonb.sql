/** TRY QUERY JSON DATA IN POSTGRES
 * 
 * TABLE_NAME: exercise_list
 * COLUMN: {
 * 		id: int, auto increment,
 * 		name: varchar, not null,
 * 		type: varchar, not null,
 * 		date_infos: JSONB, //array data
 * 		contact: JSONB null // object data
 * }
 * 
 * [NOTES] -> VS ->>
 * 	-> which returns the JSONB object from the emp table
 * 	->> to get the data associated with the name key from the JSONB column and retrieve it as text
 * **/


-- 1. CREATE TABLE Exercise List
CREATE TABLE exercise_list (
  id SERIAL PRIMARY KEY,
  name varchar not null,
  type varchar not null,
  date_infos JSONB,
  contact JSONB null
);


--2. INSERT DATA
INSERT INTO exercise_list(name,type,date_infos, contact) 
VALUES 
  (
    'swimming',
    'fix_date', 
    '[{"date":"2024-04-01","hours":[{"start":"01:00","end":"02:00"},{"start":"12:00","end":"13:01"}]}]',
    '{"phone":"08121009988","email":"andhi@gmail.com"}'
  ),
  (
    'reading',
    'fix_date', 
    '[{"date":"2024-05-01","hours":[{"start":"01:00","end":"02:00"},{"start":"10:00","end":"13:01"}]}]',
    '{"phone":"08121009970","email":"ayu@gmail.com"}'
  ),
  (
    'swimming',
    'multiple_date', 
    '[{"date":"2024-04-01","hours":[{"start":"01:00","end":"02:00"},{"start":"12:00","end":"13:01"}]},{"date":"2024-06-01","hours":[{"start":"01:00","end":"02:00"},{"start":"12:00","end":"13:01"}]}]',
    '{"phone":"08121009901","email":"jes@gmail.com"}'
  );

 
 
--3.[QUERY Object JSONB] Get data by contact.phone
SELECT id, name, type, contact -> 'phone' as phone, contact ->> 'email' as email
from exercise_list el where contact ->> 'phone' = '08121009970';

/** RESULT
 * 
 *  id|name   |type    |phone        |email        |
	--+-------+--------+-------------+-------------+
	 2|reading|fix_date|"08121009970"|ayu@gmail.com|
 */



--4.[QUERY Array JSONB] #1 Get data by date_infos
SELECT id, name, type, contact -> 'phone' as phone, contact ->> 'email' as email 
FROM 
  exercise_list el 
WHERE 
  date_infos  @> '[{"date": "2024-04-01"}]' :: jsonb
  
/** RESULT
 * 
 *  id|name    |type         |phone        |email          |
	--+--------+-------------+-------------+---------------+
	 1|swimming|fix_date     |"08121009988"|andhi@gmail.com|
	 3|swimming|multiple_date|"08121009901"|jes@gmail.com  |
	 
 * **/
  
  
--5. [QUERY Array JSONB] #2 Get data by date_infos
SELECT id, name ,type, arr.position, arr.item_object
FROM exercise_list el ,
jsonb_array_elements(date_infos) with ordinality arr(item_object, position) 
WHERE item_object ->> 'date' = '2024-04-01'
and item_object -> 'hours' @> '[{"start": "01:00", "end": "02:00"}]';

/**RESULT
 * 
 *  id|name    |type         |position|item_object                                                                                              |
	--+--------+-------------+--------+---------------------------------------------------------------------------------------------------------+
	 1|swimming|fix_date     |       1|{"date": "2024-04-01", "hours": [{"end": "02:00", "start": "01:00"}, {"end": "13:01", "start": "12:00"}]}|
	 3|swimming|multiple_date|       1|{"date": "2024-04-01", "hours": [{"end": "02:00", "start": "01:00"}, {"end": "13:01", "start": "12:00"}]}|
 * **/

-- CREATE TABLE Excercise List
CREATE TABLE excercise_list (
  id SERIAL PRIMARY KEY,
  name varchar not null,
  type varchar not null,
  date_infos JSONB,
  contact JSONB null
);


--INSERT DATA
INSERT INTO excercise_list(name,type,date_infos, contact) 
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
  );
 
 INSERT INTO excercise_list(name,type,date_infos, contact) 
VALUES 
  (
    'swimming',
    'multiple_date', 
    '[{"date":"2024-04-01","hours":[{"start":"01:00","end":"02:00"},{"start":"12:00","end":"13:01"}]},{"date":"2024-06-01","hours":[{"start":"01:00","end":"02:00"},{"start":"12:00","end":"13:01"}]}]',
    '{"phone":"08121009901","email":"jes@gmail.com"}'
  );


--[NOTES] -> VS ->>
-- #  -> which returns the JSONB object from the emp table
-- # ->> to get the data associated with the name key from the JSONB column and retrieve it as text
 
-- [Object JSONB] Get data by contact.phone
SELECT id, name, type, contact -> 'phone' as phone, contact ->> 'email' as email
from excercise_list el where contact ->> 'phone' = '08121009970';

-- [Array JSONB] #1 Get data by date_infos
SELECT id, name, type, contact -> 'phone' as phone, contact ->> 'email' as email 
FROM 
  excercise_list el 
WHERE 
  date_infos  @> '[{"date": "2024-04-01"}]' :: jsonb
  
-- [Array JSONB] #2 Get data by date_infos
SELECT id, name ,type, arr.position, arr.item_object
FROM excercise_list el ,
jsonb_array_elements(date_infos) with ordinality arr(item_object, position) 
WHERE item_object ->> 'date' = '2024-04-01'
and item_object -> 'hours' @> '[{"start": "01:00", "end": "02:00"}]';
  
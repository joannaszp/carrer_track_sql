USE sql_and_tableau;

SELECT *,
CASE WHEN days_for_completion = 0 THEN 'Same day'
WHEN (days_for_completion >= 1  AND days_for_completion < 8) THEN '1 to 7 days'
WHEN (days_for_completion >= 8  AND days_for_completion < 31) THEN '8 to 30 days'
WHEN (days_for_completion >= 31  AND days_for_completion < 61) THEN '31 to 60 days'
WHEN (days_for_completion >= 61  AND days_for_completion < 91) THEN '61 to 90 days'
WHEN (days_for_completion >= 91  AND days_for_completion < 366) THEN '91 to 365 days'
WHEN days_for_completion >= 366 THEN '366+ days'
END AS completion_bucket
FROM
(SELECT
e.student_id,
i.track_name,
e.date_enrolled,
e.date_completed,
ROW_NUMBER () OVER(ORDER BY e.student_id, e.track_id DESC) AS student_track_id,
IF(e.date_completed IS NULL, 0, 1) AS track_completed,
DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
FROM career_track_student_enrollments e
LEFT JOIN career_track_info i 
ON e.track_id = i.track_id) a;
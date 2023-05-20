/*
Group 17: Karty Dhuper, Jack Mahedy, Ryan Melenchuk, & Ethan Zeronik
CNIT372
*/
-- 372 Baseball Project Questions ----------------------------------------------
-- Question 1: What is a given team's batting average in a given year?

CREATE OR REPLACE PROCEDURE TeamBattAvg (p_team IN gamelogs.hometeam%TYPE, p_year IN varchar2) AS
    v_visitingAtBats gamelogs.visitingatbats%TYPE;
    v_visitingHits gamelogs.visitinghits%TYPE;
    v_homeAtBats gamelogs.homeatbats%TYPE;
    v_homeHits gamelogs.homehits%TYPE;
    v_totalAtBats gamelogs.homeatbats%TYPE;
    v_totalHits gamelogs.homehits%TYPE;
    v_battAvg NUMBER(4,3);
BEGIN
    SELECT sum(visitingAtBats), sum(visitingHits)
    INTO v_visitingAtBats, v_visitingHits
    FROM gamelogs
    WHERE (p_team LIKE visitingTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
    
    SELECT sum(homeAtBats), sum(homeHits)
    INTO v_homeAtBats, v_homeHits
    FROM gamelogs
    WHERE (p_team LIKE homeTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
    
    v_totalAtBats := v_visitingAtBats + v_homeAtBats;
    v_totalHits := v_visitingHits + v_homeHits;
    v_battAvg := v_totalHits/v_totalAtBats;
    
    dbms_output.put_line(p_team || '''s team-wide batting average for the '|| p_year || ' season is: ' || v_battAvg);      
END TeamBattAvg;
/
EXEC TeamBattAvg('NYA','2021');
---------------------------------------------------------------------------------------------------------------------

-- Question 2: What home and visiting teams had the most strike-outs in a given year? 

CREATE OR REPLACE PROCEDURE TopTeamStrikeouts (p_year IN varchar2) AS
    v_visitingStrikeouts gamelogs.visitingstrikeouts%TYPE;
    v_homeStrikeouts gamelogs.homestrikeouts%TYPE;
    v_vTeam gamelogs.visitingteam%TYPE;
    v_hTeam gamelogs.hometeam%TYPE;
BEGIN
    SELECT visitingTeam
    INTO v_vTeam
    FROM gamelogs
    WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
    GROUP BY visitingTeam
    HAVING sum(visitingStrikeouts) IN (SELECT max(sum(visitingStrikeouts))
                                       FROM gamelogs
                                       WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
                                       GROUP BY visitingTeam);
    SELECT max(sum(visitingStrikeouts))
    INTO v_visitingStrikeouts
    FROM gamelogs
    WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
    GROUP BY visitingTeam;
    
    SELECT homeTeam
    INTO v_hTeam
    FROM gamelogs
    WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
    GROUP BY homeTeam
    HAVING sum(homeStrikeouts) IN (SELECT max(sum(homeStrikeouts))
                                   FROM gamelogs
                                   WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
                                   GROUP BY homeTeam);
    SELECT max(sum(homeStrikeouts))
    INTO v_homeStrikeouts
    FROM gamelogs
    WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
    GROUP BY homeTeam;
    
   dbms_output.put_line(v_vTeam || ' had the most visiting strikeouts in ' || p_year || ' with ' || v_visitingStrikeouts || ' strikeouts.');
   dbms_output.put_line(v_hTeam || ' had the most home strikeouts in ' || p_year || ' with ' || v_homeStrikeouts || ' strikeouts.');
END TopTeamStrikeouts;
/
EXEC TopTeamStrikeouts('1997');
---------------------------------------------------------------------------------------------------------------------

-- Question 3: What is the career-average game duration for every park?

CREATE OR REPLACE PROCEDURE parkGameDuration
AS
    CURSOR all_parks
    IS
        SELECT parkid, nvl(round(avg(timeInMinutes),0),'0') AS avg_time
        FROM gamelogs
        GROUP BY parkid;        
    current_park all_parks%ROWTYPE;    
BEGIN
    OPEN all_parks;   
    FETCH all_parks INTO current_park;
    WHILE all_parks%FOUND LOOP
        DBMS_OUTPUT.PUT (RPAD(current_park.parkid, 10, ' '));
        DBMS_OUTPUT.PUT_LINE (current_park.avg_time);
        FETCH all_parks INTO current_park;
    END LOOP;
    CLOSE all_parks;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT(SQLCODE);
        DBMS_OUTPUT.PUT(': ');
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 100));
END parkGameDuration;
/
EXEC parkGameDuration;
---------------------------------------------------------------------------------------------------------------------

-- Question 4: What is the average attendance for a given stadium in a given year? 

CREATE OR REPLACE PROCEDURE ParkAttendAvg (p_park IN gamelogs.parkid%TYPE, p_year IN varchar2) AS
    v_avgAttend gamelogs.attendance%TYPE;
BEGIN
    SELECT avg(attendance)
    INTO v_avgAttend
    FROM gamelogs
    WHERE (p_park LIKE parkid) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));

    dbms_output.put_line('Stadium ' || p_park || '''s average attendance for the ' || p_year || ' season was: ' || v_avgAttend);

END ParkAttendAvg;
/
EXEC ParkAttendAvg('NYC21','2021');
---------------------------------------------------------------------------------------------------------------------

-- Question 5: How many home runs did a given team get in a given year?

CREATE OR REPLACE PROCEDURE TeamHomeRuns (p_team IN gamelogs.hometeam%TYPE, p_year IN varchar2) AS
    v_visitingHomeRun gamelogs.visitinghomeruns%TYPE;
    v_homeHomeRun gamelogs.homehomeruns%TYPE;
    v_total gamelogs.homehomeruns%TYPE;
BEGIN
    SELECT sum(visitinghomeruns)
    INTO v_visitingHomeRun
    FROM gamelogs
    WHERE (p_team LIKE visitingTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));

    SELECT sum(homehomeruns)
    INTO v_homeHomeRun
    FROM gamelogs
    WHERE (p_team LIKE homeTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));

    v_total := v_visitingHomeRun + v_homeHomeRun;
    dbms_output.put_line(p_team || ' had a total of ' || v_total || ' home runs in the ' || p_year || ' season.');

END TeamHomeRuns;
/
EXEC TeamHomeRuns('ATL','2005');
---------------------------------------------------------------------------------------------------------------------

-- Question 6: Who were the umpires at a given stadium on a given date?

CREATE OR REPLACE PROCEDURE GameUmpires (p_park IN gamelogs.parkid%TYPE, p_date IN varchar2) AS
    v_homePlateUmp gamelogs.homeplateumpireid%TYPE;
    v_firstBaseUmp gamelogs.firstbaseumpireid%TYPE;
    v_secondBaseUmp gamelogs.secondbaseumpireid%TYPE;
    v_thirdBaseUmp gamelogs.thirdbaseumpireid%TYPE;
BEGIN
    SELECT homeplateumpireid, firstbaseumpireid, secondbaseumpireid, thirdbaseumpireid
    INTO v_homePlateUmp, v_firstBaseUmp, v_secondBaseUmp, v_thirdBaseUmp
    FROM gamelogs
    WHERE (p_park LIKE parkid) AND (p_date = trim(TO_CHAR(gamedate, 'MM-DD-YYYY')));

    dbms_output.put_line('On ' || p_date || ' at stadium ' || p_park || ' the umpires were: ' || v_homePlateUmp || ', '  
                                                                                              || v_firstBaseUmp || ', ' 
                                                                                              || v_secondBaseUmp || ', and '
                                                                                              || v_thirdBaseUmp);
END GameUmpires;
/
EXEC GameUmpires('CHI11','04-24-1986');
---------------------------------------------------------------------------------------------------------------------

-- Question 7: How likely is the home team to win the game if it rains?

CREATE OR REPLACE FUNCTION odds_of_home_team_win_if_rain (
    p_team IN gamelogs.hometeam%type
) RETURN NUMBER IS
    v_numwon  NUMBER;
    v_numlost NUMBER;
BEGIN
 -- games won
    SELECT COUNT ( * ) INTO v_numwon
    FROM gamelogs
        LEFT JOIN schedule
        ON gamelogs.gamedate = schedule.dateofmakeup AND gamelogs.gamenumber = schedule.hometeamgameamount AND gamelogs.hometeam = schedule.hometeam
    WHERE gamelogs.hometeam LIKE p_team AND (gamelogs.homescore > gamelogs.visitingscore) AND schedule.gamestatus LIKE '%Rain%';
 -- games lost
    SELECT COUNT ( * ) INTO v_numlost
    FROM gamelogs
        LEFT JOIN schedule
        ON gamelogs.gamedate = schedule.dateofmakeup AND gamelogs.gamenumber = schedule.hometeamgameamount AND gamelogs.hometeam = schedule.hometeam
    WHERE gamelogs.hometeam LIKE p_team AND (gamelogs.homescore <= gamelogs.visitingscore) AND schedule.gamestatus LIKE '%Rain%';
 -- calc odds
    IF v_numlost = 0 THEN
        RETURN v_numwon / 1;
    ELSE
        RETURN v_numwon / v_numlost;
    END IF;
END odds_of_home_team_win_if_rain;
/
DECLARE
    v_team VARCHAR2(3) := 'HOU';
BEGIN
    -- run function
    dbms_output.put_line('The ' || v_team || ' team has a ' || odds_of_home_team_win_if_rain(v_team) ||
        '% chance of winning a game in the rain according to historic data.');
END;
---------------------------------------------------------------------------------------------------------------------

-- Question 8: What is the most consistent batting average?

CREATE OR REPLACE PROCEDURE most_consistent_batting_avg AS
    o_batt_avg   NUMBER;
    o_batt_count NUMBER;
BEGIN
 -- table of batting averages
    SELECT trunc (AVG (visitinghits / visitingatbats) , 3) , COUNT ( * ) INTO o_batt_avg, o_batt_count
    FROM gamelogs
    GROUP BY trunc (visitinghits / visitingatbats, 3)
    ORDER BY COUNT (visitinghits) DESC FETCH FIRST 1 ROWS ONLY;
 --
    dbms_output.put_line ('The most consistent batting avereage is ' || o_batt_avg || ' with ' || o_batt_count || ' occurrences.');
END most_consistent_batting_avg;
/
EXEC most_consistent_batting_avg;
---------------------------------------------------------------------------------------------------------------------

-- Question 9: Given a date and a stadium, how long was the game?

CREATE OR REPLACE PROCEDURE GameLength (p_date IN varchar2, p_park IN GAMELOGS.PARKID%TYPE)
    AS V_GameLength gamelogs.timeinminutes%type;
BEGIN 
    SELECT timeinminutes	
    INTO V_GameLength
    FROM gamelogs
    WHERE (p_park LIKE parkid) AND (p_date = trim(TO_CHAR(gamedate, 'MM-DD-YYYY')));

    dbms_output.put_line('The game on ' || p_date || ' at stadium ' || p_park || ' was played for '|| V_GameLength ||' minutes.');
EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE = +100 THEN
        dbms_output.put_line(SQLERRM);
        dbms_output.put_line('There were no games played in this park on ' || p_date || ', or that is not a valid park id.');
    ELSE
        RAISE;
    END IF;
END GameLength;
/
EXEC GameLength('09-18-1998', 'DET04');
---------------------------------------------------------------------------------------------------------------------

-- Question 10: Given a year, which teams were above or below the seasonal average of stolen bases as visiting teams?

CREATE OR REPLACE PROCEDURE TopAndBottom50Teams(p_year IN VARCHAR2) AS
    CURSOR top50 IS
        SELECT visitingTeam, round(avg(visitingStolenBases),2) AS Avg_Stolen_Bases
        FROM gamelogs
        WHERE (visitingStolenBases IS NOT NULL) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
        GROUP BY visitingTeam
        HAVING avg(visitingStolenBases) > (SELECT avg(visitingStolenBases)
                                           FROM gamelogs
                                           WHERE TO_CHAR(gamedate, 'YYYY') LIKE '2016')
        ORDER BY avg(visitingStolenBases) DESC;
    current_top50 top50%ROWTYPE;
    
    CURSOR bot50 IS
        SELECT visitingTeam, round(avg(visitingStolenBases),2) AS Avg_Stolen_Bases
        FROM gamelogs
        WHERE (visitingStolenBases IS NOT NULL) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
        GROUP BY visitingTeam
        HAVING avg(visitingStolenBases) < (SELECT avg(visitingStolenBases)
                                           FROM gamelogs
                                           WHERE TO_CHAR(gamedate, 'YYYY') LIKE '2016')
        ORDER BY avg(visitingStolenBases) DESC;
    current_bot50 bot50%ROWTYPE;
BEGIN
    dbms_output.put_line('The following teams have above-average stolen bases as the visiting team in ' || p_year);
    OPEN top50;
        FETCH top50 INTO current_top50;
        WHILE top50%FOUND LOOP
            DBMS_OUTPUT.PUT (RPAD(current_top50.visitingTeam, 10, ' '));
            DBMS_OUTPUT.PUT_LINE (current_top50.Avg_Stolen_Bases);
            FETCH top50 INTO current_top50;
        END LOOP;
        CLOSE top50;
    dbms_output.put_line('The following teams have below-average stolen bases as the visiting team in ' || p_year); 
    OPEN bot50;
        FETCH bot50 INTO current_bot50;
        WHILE bot50%FOUND LOOP
            DBMS_OUTPUT.PUT (RPAD(current_bot50.visitingTeam, 10, ' '));
            DBMS_OUTPUT.PUT_LINE (current_bot50.Avg_Stolen_Bases);
            FETCH bot50 INTO current_bot50;
        END LOOP;
        CLOSE bot50;      
END TopAndBottom50Teams;
/
EXEC TopAndBottom50Teams('2016');
---------------------------------------------------------------------------------------------------------------------

-- Trigger
CREATE TABLE audits (
    audit_id   NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    username   VARCHAR2(15),
    event_type VARCHAR2(30),
    logon_date DATE,
    logon_time VARCHAR2(15),
    logof_date DATE,
    logof_time VARCHAR2(15)
);
/
CREATE OR REPLACE TRIGGER audit_logon_trg
AFTER LOGON ON SCHEMA
BEGIN
    INSERT INTO audits(username, event_type, logon_date, logon_time, logof_date, logof_time)
        VALUES(user, ora_sysevent, sysdate, TO_CHAR(sysdate, 'hh24:mi:ss'), NULL, NULL);
END;
/
CREATE OR REPLACE TRIGGER audit_logoff_trg
BEFORE LOGOFF ON SCHEMA
BEGIN
    INSERT INTO audits(username, event_type, logon_date, logon_time, logof_date, logof_time)
        VALUES(user, ora_sysevent, NULL, NULL, sysdate, TO_CHAR(sysdate, 'hh24:mi:ss'));
END;
/
SELECT * FROM AUDITS;
---------------------------------------------------------------------------------------------------------------------

-- Package

CREATE OR REPLACE PACKAGE PKG_HOMERUN_DB IS
    PROCEDURE TeamBattAvg (p_team IN gamelogs.hometeam%TYPE, p_year IN varchar2);
    PROCEDURE TopTeamStrikeouts (p_year IN varchar2);
    PROCEDURE parkGameDuration;
    PROCEDURE ParkAttendAvg (p_park IN gamelogs.parkid%TYPE, p_year IN varchar2);
    PROCEDURE TeamHomeRuns (p_team IN gamelogs.hometeam%TYPE, p_year IN varchar2);
    PROCEDURE GameUmpires (p_park IN gamelogs.parkid%TYPE, p_date IN varchar2);
    FUNCTION odds_of_home_team_win_if_rain (p_team IN gamelogs.hometeam%type)
        RETURN NUMBER;
    PROCEDURE most_consistent_batting_avg;
    PROCEDURE GameLength (p_date IN varchar2, p_park IN GAMELOGS.PARKID%TYPE);
    PROCEDURE TopAndBottom50Teams(p_year IN VARCHAR2);
END PKG_HOMERUN_DB;

CREATE OR REPLACE PACKAGE BODY PKG_HOMERUN_DB IS

    -- Q1 ------------------------------------------------------------------------
    PROCEDURE TeamBattAvg (p_team IN gamelogs.hometeam%TYPE, p_year IN varchar2) AS
        v_visitingAtBats gamelogs.visitingatbats%TYPE;
        v_visitingHits gamelogs.visitinghits%TYPE;
        v_homeAtBats gamelogs.homeatbats%TYPE;
        v_homeHits gamelogs.homehits%TYPE;
        v_totalAtBats gamelogs.homeatbats%TYPE;
        v_totalHits gamelogs.homehits%TYPE;
        v_battAvg NUMBER(4,3);
    BEGIN
        SELECT sum(visitingAtBats), sum(visitingHits)
        INTO v_visitingAtBats, v_visitingHits
        FROM gamelogs
        WHERE (p_team LIKE visitingTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
        
        SELECT sum(homeAtBats), sum(homeHits)
        INTO v_homeAtBats, v_homeHits
        FROM gamelogs
        WHERE (p_team LIKE homeTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
        
        v_totalAtBats := v_visitingAtBats + v_homeAtBats;
        v_totalHits := v_visitingHits + v_homeHits;
        v_battAvg := v_totalHits/v_totalAtBats;
        
        dbms_output.put_line(p_team || '''s team-wide batting average for the '|| p_year || ' season is: ' || v_battAvg);      
    END TeamBattAvg;

    -- Q2 ------------------------------------------------------------------------
    PROCEDURE TopTeamStrikeouts (p_year IN varchar2) AS
        v_visitingStrikeouts gamelogs.visitingstrikeouts%TYPE;
        v_homeStrikeouts gamelogs.homestrikeouts%TYPE;
        v_vTeam gamelogs.visitingteam%TYPE;
        v_hTeam gamelogs.hometeam%TYPE;
    BEGIN
        SELECT visitingTeam
        INTO v_vTeam
        FROM gamelogs
        WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
        GROUP BY visitingTeam
        HAVING sum(visitingStrikeouts) IN (SELECT max(sum(visitingStrikeouts))
                                           FROM gamelogs
                                           WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
                                           GROUP BY visitingTeam);
        SELECT max(sum(visitingStrikeouts))
        INTO v_visitingStrikeouts
        FROM gamelogs
        WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
        GROUP BY visitingTeam;
        
        SELECT homeTeam
        INTO v_hTeam
        FROM gamelogs
        WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
        GROUP BY homeTeam
        HAVING sum(homeStrikeouts) IN (SELECT max(sum(homeStrikeouts))
                                       FROM gamelogs
                                       WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
                                       GROUP BY homeTeam);
        SELECT max(sum(homeStrikeouts))
        INTO v_homeStrikeouts
        FROM gamelogs
        WHERE (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
        GROUP BY homeTeam;
        
       dbms_output.put_line(v_vTeam || ' had the most visiting strikeouts in ' || p_year || ' with ' || v_visitingStrikeouts || ' strikeouts.');
       dbms_output.put_line(v_hTeam || ' had the most home strikeouts in ' || p_year || ' with ' || v_homeStrikeouts || ' strikeouts.');
    END TopTeamStrikeouts;

    -- Q3 ------------------------------------------------------------------------
    PROCEDURE parkGameDuration AS
        CURSOR all_parks IS
            SELECT parkid, nvl(round(avg(timeInMinutes),0),'0') AS avg_time
            FROM gamelogs
            GROUP BY parkid;        
        current_park all_parks%ROWTYPE;    
    BEGIN
        OPEN all_parks;   
        FETCH all_parks INTO current_park;
        WHILE all_parks%FOUND LOOP
            DBMS_OUTPUT.PUT (RPAD(current_park.parkid, 10, ' '));
            DBMS_OUTPUT.PUT_LINE (current_park.avg_time);
            FETCH all_parks INTO current_park;
        END LOOP;
        CLOSE all_parks;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT(SQLCODE);
            DBMS_OUTPUT.PUT(': ');
            DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 100));
    END parkGameDuration;

    -- Q4 ------------------------------------------------------------------------
    PROCEDURE ParkAttendAvg (p_park IN gamelogs.parkid%TYPE, p_year IN varchar2) AS
        v_avgAttend gamelogs.attendance%TYPE;
    BEGIN
        SELECT avg(attendance)
        INTO v_avgAttend
        FROM gamelogs
        WHERE (p_park LIKE parkid) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
    
        dbms_output.put_line('Stadium ' || p_park || '''s average attendance for the ' || p_year || ' season was: ' || v_avgAttend);    
    END ParkAttendAvg;

    -- Q5 ------------------------------------------------------------------------
    PROCEDURE TeamHomeRuns (p_team IN gamelogs.hometeam%TYPE, p_year IN varchar2) AS
        v_visitingHomeRun gamelogs.visitinghomeruns%TYPE;
        v_homeHomeRun gamelogs.homehomeruns%TYPE;
        v_total gamelogs.homehomeruns%TYPE;
    BEGIN
        SELECT sum(visitinghomeruns)
        INTO v_visitingHomeRun
        FROM gamelogs
        WHERE (p_team LIKE visitingTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
    
        SELECT sum(homehomeruns)
        INTO v_homeHomeRun
        FROM gamelogs
        WHERE (p_team LIKE homeTeam) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')));
    
        v_total := v_visitingHomeRun + v_homeHomeRun;
        dbms_output.put_line(p_team || ' had a total of ' || v_total || ' home runs in the ' || p_year || ' season.');
    END TeamHomeRuns;

    -- Q6 ------------------------------------------------------------------------
    PROCEDURE GameUmpires (p_park IN gamelogs.parkid%TYPE, p_date IN varchar2) AS
        v_homePlateUmp gamelogs.homeplateumpireid%TYPE;
        v_firstBaseUmp gamelogs.firstbaseumpireid%TYPE;
        v_secondBaseUmp gamelogs.secondbaseumpireid%TYPE;
        v_thirdBaseUmp gamelogs.thirdbaseumpireid%TYPE;
    BEGIN
        SELECT homeplateumpireid, firstbaseumpireid, secondbaseumpireid, thirdbaseumpireid
        INTO v_homePlateUmp, v_firstBaseUmp, v_secondBaseUmp, v_thirdBaseUmp
        FROM gamelogs
        WHERE (p_park LIKE parkid) AND (p_date = trim(TO_CHAR(gamedate, 'MM-DD-YYYY')));
    
        dbms_output.put_line('On ' || p_date || ' at stadium ' || p_park || ' the umpires were: ' || v_homePlateUmp || ', '  
                                                                                                  || v_firstBaseUmp || ', ' 
                                                                                                  || v_secondBaseUmp || ', and '
                                                                                                  || v_thirdBaseUmp);
    END GameUmpires;

    -- Q7 ------------------------------------------------------------------------
    FUNCTION odds_of_home_team_win_if_rain (
        p_team IN gamelogs.hometeam%type
    ) RETURN NUMBER IS
        v_numwon  NUMBER;
        v_numlost NUMBER;
    BEGIN
     -- games won
        SELECT COUNT ( * ) INTO v_numwon
        FROM gamelogs
            LEFT JOIN schedule
            ON gamelogs.gamedate = schedule.dateofmakeup AND gamelogs.gamenumber = schedule.hometeamgameamount AND gamelogs.hometeam = schedule.hometeam
        WHERE gamelogs.hometeam LIKE p_team AND (gamelogs.homescore > gamelogs.visitingscore) AND schedule.gamestatus LIKE '%Rain%';
     -- games lost
        SELECT COUNT ( * ) INTO v_numlost
        FROM gamelogs
            LEFT JOIN schedule
            ON gamelogs.gamedate = schedule.dateofmakeup AND gamelogs.gamenumber = schedule.hometeamgameamount AND gamelogs.hometeam = schedule.hometeam
        WHERE gamelogs.hometeam LIKE p_team AND (gamelogs.homescore <= gamelogs.visitingscore) AND schedule.gamestatus LIKE '%Rain%';
     -- calc odds
        RETURN v_numwon / v_numlost;
    END odds_of_home_team_win_if_rain;

    -- Q8 ------------------------------------------------------------------------
    PROCEDURE most_consistent_batting_avg AS
        o_batt_avg   NUMBER;
        o_batt_count NUMBER;
    BEGIN
     -- table of batting averages
        SELECT trunc (AVG (visitinghits / visitingatbats) , 3) , COUNT ( * ) INTO o_batt_avg, o_batt_count
        FROM gamelogs
        GROUP BY trunc (visitinghits / visitingatbats, 3)
        ORDER BY COUNT (visitinghits) DESC FETCH FIRST 1 ROWS ONLY;
     --
        dbms_output.put_line ('The most consistent batting avereage is ' || o_batt_avg || ' with ' || o_batt_count || ' occurrences.');
    END most_consistent_batting_avg;

    -- Q9 ------------------------------------------------------------------------
    PROCEDURE GameLength (p_date IN varchar2, p_park IN GAMELOGS.PARKID%TYPE)
    AS V_GameLength gamelogs.timeinminutes%type;
    BEGIN 
        SELECT timeinminutes	
        INTO V_GameLength
        FROM gamelogs
        WHERE (p_park LIKE parkid) AND (p_date = trim(TO_CHAR(gamedate, 'MM-DD-YYYY')));
    
        dbms_output.put_line('The game on ' || p_date || ' at stadium ' || p_park || ' was played for '|| V_GameLength ||' minutes.');
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = +100 THEN
            dbms_output.put_line(SQLERRM);
            dbms_output.put_line('There were no games played in this park on ' || p_date || ', or that is not a valid park id.');
        ELSE
            RAISE;
        END IF;
    END GameLength;

    -- Q10 ------------------------------------------------------------------------
    PROCEDURE TopAndBottom50Teams(p_year IN VARCHAR2) AS
        CURSOR top50 IS
            SELECT visitingTeam, round(avg(visitingStolenBases),2) AS Avg_Stolen_Bases
            FROM gamelogs
            WHERE (visitingStolenBases IS NOT NULL) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
            GROUP BY visitingTeam
            HAVING avg(visitingStolenBases) > (SELECT avg(visitingStolenBases)
                                               FROM gamelogs
                                               WHERE TO_CHAR(gamedate, 'YYYY') LIKE '2016')
            ORDER BY avg(visitingStolenBases) DESC;
        current_top50 top50%ROWTYPE;
        
        CURSOR bot50 IS
            SELECT visitingTeam, round(avg(visitingStolenBases),2) AS Avg_Stolen_Bases
            FROM gamelogs
            WHERE (visitingStolenBases IS NOT NULL) AND (p_year = trim(TO_CHAR(gamedate, 'YYYY')))
            GROUP BY visitingTeam
            HAVING avg(visitingStolenBases) < (SELECT avg(visitingStolenBases)
                                               FROM gamelogs
                                               WHERE TO_CHAR(gamedate, 'YYYY') LIKE '2016')
            ORDER BY avg(visitingStolenBases) DESC;
        current_bot50 bot50%ROWTYPE;
    BEGIN
        dbms_output.put_line('The following teams have above-average stolen bases as the visiting team in ' || p_year);
        OPEN top50;
            FETCH top50 INTO current_top50;
            WHILE top50%FOUND LOOP
                DBMS_OUTPUT.PUT (RPAD(current_top50.visitingTeam, 10, ' '));
                DBMS_OUTPUT.PUT_LINE (current_top50.Avg_Stolen_Bases);
                FETCH top50 INTO current_top50;
            END LOOP;
            CLOSE top50;
        dbms_output.put_line('The following teams have below-average stolen bases as the visiting team in ' || p_year); 
        OPEN bot50;
            FETCH bot50 INTO current_bot50;
            WHILE bot50%FOUND LOOP
                DBMS_OUTPUT.PUT (RPAD(current_bot50.visitingTeam, 10, ' '));
                DBMS_OUTPUT.PUT_LINE (current_bot50.Avg_Stolen_Bases);
                FETCH bot50 INTO current_bot50;
            END LOOP;
            CLOSE bot50;      
    END TopAndBottom50Teams;
END PKG_HOMERUN_DB;
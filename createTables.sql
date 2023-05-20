-- drop the old table
DROP TABLE ejections CASCADE CONSTRAINTS;

-- make the table schema
CREATE TABLE ejections (
    gameid VARCHAR2 (12) NOT NULL,
    "date" date,
    gamenumber VARCHAR2 (2),
    playerid VARCHAR2 (8) NOT NULL,
    playername VARCHAR2 (30),
    team VARCHAR2 (3),
    playerrole VARCHAR2 (1),
    umpireid VARCHAR2 (8),
    umpirename VARCHAR2 (30),
    inning VARCHAR2 (2),
    reason VARCHAR2 (500)
);

-- add the PK to the table
ALTER TABLE ejections ADD CONSTRAINT ejections_pk PRIMARY KEY (gameid, playerid);
--------------------------------------------------------------------------------

-- drop the old table
DROP TABLE gamelogs CASCADE CONSTRAINTS;

-- make the table schema
CREATE TABLE gamelogs (
    gameid VARCHAR2 (12) NOT NULL,
    gamedate date,
    gamenumber VARCHAR2 (1),
    dayofweek VARCHAR2 (3),
    visitingteam VARCHAR2 (3),
    visitingleague VARCHAR2 (2),
    visitinggamenumber INTEGER,
    hometeam VARCHAR2 (3),
    homeleague VARCHAR2 (2),
    homegamenumber INTEGER,
    visitingscore INTEGER,
    homescore INTEGER,
    lengthinouts INTEGER,
    dayornight VARCHAR2 (1),
    completioninformation VARCHAR2 (25),
    forfeitinformation VARCHAR2 (1),
    protestinformation VARCHAR2 (1),
    parkid VARCHAR2 (5),
    attendance INTEGER,
    timeinminutes INTEGER,
    visitinglinescore VARCHAR2 (35),
    homelinescore VARCHAR2 (35),
    visitingatbats INTEGER,
    visitinghits INTEGER,
    visitingdoubles INTEGER,
    visitingtriples INTEGER,
    visitinghomeruns INTEGER,
    visitingrbi INTEGER,
    visitingsacrificehits INTEGER,
    visitingsacrificeflies INTEGER,
    visitinghitbypitch INTEGER,
    visitingwalks INTEGER,
    visitingintentionalwalks INTEGER,
    visitingstrikeouts INTEGER,
    visitingstolenbases INTEGER,
    visitingcaughtstealing INTEGER,
    visitinggroundintodoubleplays INTEGER,
    visitingawardedfirstoncatchint INTEGER,
    visitingleftonbase INTEGER,
    visitingpitchersused INTEGER,
    visitingindividualearnedruns INTEGER,
    visitingteamearnedruns INTEGER,
    visitingwildpitches INTEGER,
    visitingbalks INTEGER,
    visitingputouts INTEGER,
    visitingassists INTEGER,
    visitingerrors INTEGER,
    visitingpassedballs INTEGER,
    visitingdoubleplays INTEGER,
    visitingtripleplays INTEGER,
    homeatbats INTEGER,
    homehits INTEGER,
    homedoubles INTEGER,
    hometriples INTEGER,
    homehomeruns INTEGER,
    homerbi INTEGER,
    homesacrificehits INTEGER,
    homesacrificeflies INTEGER,
    homehitbypitch INTEGER,
    homewalks INTEGER,
    homeintentionalwalks INTEGER,
    homestrikeouts INTEGER,
    homestolenbases INTEGER,
    homecaughtstealing INTEGER,
    homegroundintodoubleplays INTEGER,
    homeawardedfirstoncatchint INTEGER,
    homeleftonbase INTEGER,
    homepitchersused INTEGER,
    homeindividualearnedruns INTEGER,
    hometeamearnedruns INTEGER,
    homewildpitches INTEGER,
    homebalks INTEGER,
    homeputouts INTEGER,
    homeassists INTEGER,
    homeerrors INTEGER,
    homepassedballs INTEGER,
    homedoubleplays INTEGER,
    hometripleplays INTEGER,
    homeplateumpireid VARCHAR2 (8),
    firstbaseumpireid VARCHAR2 (8),
    secondbaseumpireid VARCHAR2 (8),
    thirdbaseumpireid VARCHAR2 (8),
    lfumpireid VARCHAR2 (8),
    rfumpireid VARCHAR2 (8),
    visitingteammanagerid VARCHAR2 (8),
    hometeammanagerid VARCHAR2 (8),
    winningpitcherid VARCHAR2 (8),
    losingpitcherid VARCHAR2 (8),
    savingpitcherid VARCHAR2 (8),
    gamewinningrbibatterid VARCHAR2 (8),
    visitingstartingpitcherid VARCHAR2 (8),
    homestartingpitcherid VARCHAR2 (8),
    visitingstartingplayer1id VARCHAR2 (8),
    visitingstartingplayer1pos VARCHAR2 (2),
    visitingstartingplayer2id VARCHAR2 (8),
    visitingstartingplayer2pos VARCHAR2 (2),
    visitingstartingplayer3id VARCHAR2 (8),
    visitingstartingplayer3pos VARCHAR2 (2),
    visitingstartingplayer4id VARCHAR2 (8),
    visitingstartingplayer4pos VARCHAR2 (2),
    visitingstartingplayer5id VARCHAR2 (8),
    visitingstartingplayer5pos VARCHAR2 (2),
    visitingstartingplayer6id VARCHAR2 (8),
    visitingstartingplayer6pos VARCHAR2 (2),
    visitingstartingplayer7id VARCHAR2 (8),
    visitingstartingplayer7pos VARCHAR2 (2),
    visitingstartingplayer8id VARCHAR2 (8),
    visitingstartingplayer8pos VARCHAR2 (2),
    visitingstartingplayer9id VARCHAR2 (8),
    visitingstartingplayer9pos VARCHAR2 (2),
    homestartingplayer1id VARCHAR2 (8),
    homestartingplayer1pos VARCHAR2 (2),
    homestartingplayer2id VARCHAR2 (8),
    homestartingplayer2pos VARCHAR2 (2),
    homestartingplayer3id VARCHAR2 (8),
    homestartingplayer3pos VARCHAR2 (2),
    homestartingplayer4id VARCHAR2 (8),
    homestartingplayer4pos VARCHAR2 (2),
    homestartingplayer5id VARCHAR2 (8),
    homestartingplayer5pos VARCHAR2 (2),
    homestartingplayer6id VARCHAR2 (8),
    homestartingplayer6pos VARCHAR2 (2),
    homestartingplayer7id VARCHAR2 (8),
    homestartingplayer7pos VARCHAR2 (2),
    homestartingplayer8id VARCHAR2 (8),
    homestartingplayer8pos VARCHAR2 (2),
    homestartingplayer9id VARCHAR2 (8),
    homestartingplayer9pos VARCHAR2 (2),
    additionalinformation VARCHAR2 (500),
    aquisitioninformation VARCHAR2 (1)
);

-- add the PK to the table
ALTER TABLE gamelogs ADD CONSTRAINT gamelogs_pk PRIMARY KEY (id);
--------------------------------------------------------------------------------

-- drop the old table
DROP TABLE person CASCADE CONSTRAINTS;

-- make the table schema
CREATE TABLE person (
    playerid VARCHAR2 (8) NOT NULL,
    lastname VARCHAR2 (30),
    firstname VARCHAR2 (50),
    usename VARCHAR2 (30),
    birthdate date,
    birthcity VARCHAR2 (50),
    birthstate VARCHAR2 (30),
    birthcountry VARCHAR2 (30),
    debutdateasplayer date,
    dateoflastgameasplayer date,
    debutdateasmanager date,
    dateoflastgameasmanager date,
    debutdateascoach date,
    dateoflastgameascoach date,
    debutdateasumpire date,
    dateoflastgameasumpire date,
    deathdate date,
    deathcity VARCHAR2 (50),
    deathstate VARCHAR2 (50),
    deathcountry VARCHAR2 (30),
    bat VARCHAR2 (1),
    throws VARCHAR2 (1),
    height VARCHAR2 (6),
    weight NUMBER (3),
    cemetery VARCHAR2 (50),
    cemeterycity VARCHAR2 (50),
    cemeterystate VARCHAR2 (30),
    cemeterycountry VARCHAR2 (30),
    cemeterynote VARCHAR2 (250),
    birthname VARCHAR2 (50),
    namechange VARCHAR2 (100),
    batchange VARCHAR2 (100),
    hof VARCHAR2 (100)
);

-- add the PK to the table
ALTER TABLE person ADD CONSTRAINT person_pk PRIMARY KEY (playerid);
--------------------------------------------------------------------------------

-- drop the old table
DROP TABLE schedule CASCADE CONSTRAINTS;

-- make the table schema
CREATE TABLE schedule (
    gamedate date NOT NULL,
    numberofgames VARCHAR2 (1),
    dayofweek VARCHAR2 (3),
    visitingteam VARCHAR2 (3),
    visitingteamleague VARCHAR2 (2),
    visitingteamgameamount NUMBER (3),
    hometeam VARCHAR2 (3) NOT NULL,
    hometeamleague VARCHAR2 (2),
    hometeamgameamount NUMBER (3) NOT NULL,
    timeofday VARCHAR2 (1),
    gamestatus VARCHAR2 (200),
    dateofmakeup date
);

-- add the PK to the table
ALTER TABLE schedule ADD CONSTRAINT schedule_pk PRIMARY KEY (gamedate, hometeam, hometeamgameamount);
--------------------------------------------------------------------------------

-- drop the old table
DROP TABLE transactions CASCADE CONSTRAINTS;

-- make the table schema
CREATE TABLE transactions (
    primarydate date, 
    time NUMBER (1, 0), 
    primarydateisapproximate NUMBER (1, 0), 
    secondarydate date, 
    secondarydateisapproximate NUMBER (1, 0), 
    transactionid VARCHAR2 (5) NOT NULL, 
    playerid VARCHAR2 (8) NOT NULL, 
    type VARCHAR2 (2) NOT NULL, 
    fromteam VARCHAR2 (32), 
    fromleague VARCHAR2 (32), 
    toteam VARCHAR2 (32), 
    toleague VARCHAR2 (32), 
    drafttype VARCHAR2 (3), 
    draftround NUMBER (2, 0), 
    picknumber NUMBER (2, 0), 
    otherinformation VARCHAR2 (512)
);

-- add the PK to the table
ALTER TABLE transactions ADD CONSTRAINT transactions_pk PRIMARY KEY (transactionid);


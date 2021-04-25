CREATE TABLE app_list (
  appid INTEGER,
  name VARCHAR(150),
  PRIMARY KEY (appid)
);

COPY app_list(appid, name)
FROM '/home/data/app_list.csv'
DELIMITER ','
CSV HEADER;

-- Dataset 2

CREATE TABLE steamspy (
	appid INTEGER,
  name VARCHAR(150),
  developer VARCHAR(300),
  publisher VARCHAR(150),
  score_rank INTEGER,
  positive INTEGER,
  negative INTEGER,
  userscore INTEGER,
  owners VARCHAR(100),
  average_forever INTEGER,
  average_2weeks INTEGER,
  median_forever INTEGER,
  median_2weeks INTEGER,
  price INTEGER,
  initialprice INTEGER,
  discount INTEGER,
  languages VARCHAR(400),
  genre VARCHAR(300),
  ccu INTEGER,
  tags VARCHAR(500),
  PRIMARY KEY (appid)
);

COPY steamspy(appid,name,developer,publisher,score_rank,positive,negative,userscore,owners,average_forever,average_2weeks,median_forever,median_2weeks,price,initialprice,discount,languages,genre,ccu,tags)
FROM '/home/data/steamspy_data.csv'
DELIMITER ','
CSV HEADER;

-- DATASET 3
-- No DATASET steam_app_data.csv foi necessário adequar o campo steam_appid do campo
-- "1620" para "12370" e o "1621" para "12370"


CREATE TABLE steam_data (
    id SERIAL,
    type TEXT,
    name TEXT,
    steam_appid INTEGER,
    required_age INTEGER,
    is_free BOOLEAN,
    controller_support VARCHAR(5),
    dlc TEXT,
    detailed_description TEXT,
    about_the_game TEXT,
    short_description TEXT,
    fullgame TEXT,
    supported_languages TEXT,
    header_image TEXT,
    website TEXT,
    pc_requirements TEXT,
    mac_requirements TEXT,
    linux_requirements TEXT,
    legal_notice TEXT,
    drm_notice TEXT,
    ext_user_account_notice TEXT,
    developers TEXT,
    publishers TEXT,
    demos TEXT,
    price_overview TEXT,
    packages TEXT,
    package_groups TEXT,
    platforms TEXT,
    metacritic TEXT,
    reviews TEXT,
    categories TEXT,
    genres TEXT,
    screenshots TEXT,
    movies TEXT,
    recommendations TEXT,
    achievements TEXT,
    release_date TEXT,
    support_info TEXT,
    background TEXT,
    content_descriptors TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (steam_appid) REFERENCES app_list (appid),
    FOREIGN KEY (steam_appid) REFERENCES steamspy (appid)
);

COPY steam_data(type, name,steam_appid,required_age,is_free,controller_support,dlc,detailed_description,about_the_game,short_description,fullgame,supported_languages,header_image,website,pc_requirements,mac_requirements,linux_requirements,legal_notice,drm_notice,ext_user_account_notice,developers,publishers,demos,price_overview,packages,package_groups,platforms,metacritic,reviews,categories,genres,screenshots,movies,recommendations,achievements,release_date,support_info,background,content_descriptors)
FROM '/home/data/steam_app_data.csv'
DELIMITER ','
CSV HEADER;


-- PESQUISAS

-- 2) SPECIFIC ID
SELECT a.name, a.developer
FROM steamspy a
WHERE a.appid = 15130
-- Successfully run. Total query runtime: 1.7858 msec.

db.steamspy.aggregate([{$match: {
  appid: 15130
}}, {$project: {
  _id:0, name:1, developer:1
}}]).explain("executionStats")

-- Successfully run. Total query runtime: 5.8015 msec.

-- 3) INSERT
INSERT INTO app_list(appid, name)
VALUES (19232, 'Teste de Banco')

-- INSERT 0 1

-- Successfully run. Total query runtime: 3.2201 msec.

db.app_list.insertOne({id: 19232, name: 'Teste de Banco'}).explain("executionStats")
-- Successfully run. Total query runtime: 5.668 msec.

-- 4) UPDATE
UPDATE app_list
SET name = 'Teste de jogo 2'
WHERE appid = 19232;

-- Successfully run. Total query runtime: 3.8623 msec.

db.app_list.updateOne( {"appid": 19232 }, { "$set": { "name": "Teste de jogo 2" } } )
-- Successfully run. Total query runtime: 31.8844 msec.


-- 5) DELETE
DELETE FROM app_list
WHERE appid = 19232;

-- Successfully run. Total query runtime: 41.5566 msec.

db.app_list.deleteOne({"appid": 19232})
-- Successfully run. Total query runtime: 44.1959 msec.

-- 6) AGREGATE
SELECT a.name, b.release_date 
FROM app_list a
INNER JOIN steam_data b
ON a.appid=b.steam_appid
WHERE a.appid > 10 AND a.appid < 300 
ORDER BY a.name

-- Successfully run. Total query runtime: 43.2195 msec.

db.app_list.aggregate([
  { $match:{"$and": [{"appid": {"$gte": 10}}, {"appid":{"$lte": 300}}]}
},
 
{
	$lookup:{
	 from:"steam_app",
	 localField:"appid",
	 foreignField:"steam_appid",
	 as: "new_field"
	}},{
	 $sort:{"name":1}
}
])
-- Successfully run. Total query runtime: 494.6458 msec.

-- 7) COUNT
SELECT SUM(b.positive) as total_positive, SUM(b.negative) as total_negative
FROM app_list a
INNER JOIN steamspy b
ON a.appid=b.appid
WHERE a.appid > 10 AND a.appid < 600
-- Successfully run. Total query runtime: 2.9686 msec.

db.app_list.aggregate([{
  $match: { "$and": [{"appid": {"$gt": 10}}, {"appid":{"$lt": 600}}]
}}, {$lookup: {
  from: 'steamspy',
  localField: 'appid',
  foreignField: 'appid',
  as: 'steamspy'
}}, {$unwind: {
  path: "$steamspy",
  preserveNullAndEmptyArrays: true
}}, {$group: {
  _id: "",
  positive: {$sum: "$steamspy.positive"},
  negative: {$sum: "$steamspy.negative"}
}}])

-- Successfully run. Total query runtime: 655.9571 msec.



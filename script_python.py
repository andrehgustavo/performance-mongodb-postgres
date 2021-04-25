# import the connect library from pymongo
import pymongo
from pprint import pprint
from datetime import datetime
import timeit

# declare connection instance
myclient = pymongo.MongoClient('localhost', 27017)
mydb = myclient["steam"]
mycol = mydb["app_list"]

# declare starting time
start_time = timeit.default_timer()

#Choose a query
############################################### FIND BY SPECIFIC ID###########################################################################
# pipeline = [
#     {"$match":{"appid": 15130}},
#     {"$project": {"_id": 0, "name": 1, "developer": 1}}
# ]
# mycol.aggregate(pipeline)

############################################### QUERY INSERT###########################################################################
# game = {"appid": 19232, "name": "Teste de Banco"}
# mycol.insert_one(game)

############################################### QUERY UPDATE###########################################################################
# mycol.update_one( {"appid": 19232 }, { "$set": { "name": "Teste de jogo 2" } } )

############################################### QUERY DELETE###########################################################################
# mycol.delete_one({"appid": 19232})

############################################### QUERY AGREGATE###########################################################################
# pipeline = [
#     { "$match":{"$and": [{"appid": {"$gte": 10}}, {"appid":{"$lte": 300}}]}},
#     {
# 	"$lookup": { "from":"steam_app",
# 	 "localField":"appid",
# 	 "foreignField":"steam_appid",
# 	 "as": "new_field"
 
# 	}},{
	
# 	 "$sort":{"name":1}
	
# }
# ]

# mycol.aggregate(pipeline)

############################################### QUERY COUNT###########################################################################

# pipeline = [
#     {
#         '$match': {
#             '$and': [
#                 {
#                     'appid': {
#                         '$gt': 10
#                     }
#                 }, {
#                     'appid': {
#                         '$lt': 600
#                     }
#                 }
#             ]
#         }
#     }, {
#         '$lookup': {
#             'from': 'steamspy', 
#             'localField': 'appid', 
#             'foreignField': 'appid', 
#             'as': 'steamspy'
#         }
#     }, {
#         '$unwind': {
#             'path': '$steamspy', 
#             'preserveNullAndEmptyArrays': True
#         }
#     }, {
#         '$group': {
#             '_id': '', 
#             'positive': {
#                 '$sum': '$steamspy.positive'
#             }, 
#             'negative': {
#                 '$sum': '$steamspy.negative'
#             }
#         }
#     }
# ]

# mycol.aggregate(pipeline)

###########################################################
end_time = timeit.default_timer()
time = end_time-start_time

print('time: %.4f s' % time);

millisec = time * 1000
print("Successfully run. Total query runtime: %.4f msec." % millisec)

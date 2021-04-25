# import the connect library from psycopg2
from psycopg2 import connect
import timeit

table_name = "app_list"

# declare connection instance
conn = connect(
    dbname = "steam",
    user = "postgres",
    host = "localhost",
    password = "postgres",
    port = 3000
)

# declare a cursor object from the connection
cursor = conn.cursor()

# declare starting time
start_time = timeit.default_timer()
# execute an SQL statement using the psycopg2 cursor object

#Choose a query
############################################### FIND BY SPECIFIC ID###########################################################################
# cursor.execute(f"SELECT a.name, a.developer FROM steamspy a WHERE a.appid = 15130;")

############################################### QUERY INSERT###########################################################################
# cursor.execute(f"INSERT INTO app_list(appid, name) VALUES (19232, 'Teste de Banco')")
# conn.commit()
############################################### QUERY UPDATE###########################################################################
# cursor.execute(f"" + \
#                 "UPDATE app_list " +\
#                 "SET name = 'Teste de jogo 2' " + \
#                 "WHERE appid = 19232;")
# conn.commit()
############################################### QUERY DELETE###########################################################################
# cursor.execute(f"" + \
#                 "DELETE FROM app_list " +\
#                 "WHERE appid = 19232;")
# conn.commit()
############################################### QUERY AGREGATE###########################################################################
# cursor.execute(f"" + \
#                 "SELECT a.name, b.release_date " +\
#                 "FROM app_list a " + \
#                 "INNER JOIN steam_data b " + \
#                 "ON a.appid=b.steam_appid " + \
#                 "WHERE a.appid > 10 AND a.appid < 300 " + \
#                 "ORDER BY a.name;")
############################################### QUERY COUNT###########################################################################
# cursor.execute(f"" + \
#                 "SELECT SUM(b.positive) as total_positive, SUM(b.negative) as total_negative " +\
#                 "FROM app_list a " + \
#                 "INNER JOIN steamspy b " + \
#                 "ON a.appid=b.appid " + \
#                 "WHERE a.appid > 10 AND a.appid < 600")

# calculate time lapse
end_time = timeit.default_timer()
time = end_time-start_time

# enumerate() over the PostgreSQL records
# for i, record in enumerate(cursor):
#     print ("\n", type(record))
#     print ( record )



print('time: %.4f s' % time);

millisec = time * 1000
print("Successfully run. Total query runtime: %.4f msec." % millisec)

# close the cursor object to avoid memory leaks
cursor.close()

# close the connection as well
conn.close()
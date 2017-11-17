/*
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.web.database

import com.google.inject.Singleton
import com.mongodb.MongoClient
import com.mongodb.MongoClientOptions
import com.mongodb.ServerAddress
import com.mongodb.client.MongoCollection
import com.mongodb.client.MongoDatabase
import com.mongodb.client.model.Filters
import de.thm.icampus.joomdd.ejsl.web.database.codec.SessionCodecProvider
import de.thm.icampus.joomdd.ejsl.web.database.codec.UserCodecProvider
import de.thm.icampus.joomdd.ejsl.web.database.document.Session
import de.thm.icampus.joomdd.ejsl.web.database.document.User
import org.bson.codecs.configuration.CodecRegistries
import org.bson.codecs.configuration.CodecRegistry
import de.thm.icampus.joomdd.ejsl.util.Config
import com.mongodb.MongoCredential
import java.util.Arrays

@Singleton
class DatabaseLayer {
	private static DatabaseLayer instance;
	private static MongoClient mongoClient;
	private MongoDatabase database;
	private MongoCollection<User> userCollection;
	private MongoCollection<Session> sessionCollection;
	
	Config config = Config.instance;

  	def static DatabaseLayer getInstance()
  	{
    	if (DatabaseLayer.instance === null)
    	{
      		DatabaseLayer.instance = new DatabaseLayer ();
    	}
   		return DatabaseLayer.instance;
    }

	new (){
		if (instance === null)
        {
        	var CodecRegistry codecRegistry = CodecRegistries.fromRegistries(
                CodecRegistries.fromProviders(new UserCodecProvider()),
                CodecRegistries.fromProviders(new SessionCodecProvider()),
                MongoClient.getDefaultCodecRegistry());
                
        	var MongoClientOptions options = MongoClientOptions.builder()
                .codecRegistry(codecRegistry).build();
                
            var dbHost = config.properties.getProperty("databaseHost");
            var dbPort = Integer.parseInt(config.properties.getProperty("databasePort"));
            var dbName = config.properties.getProperty("databaseName");
            var dbUser = config.properties.getProperty("databaseUser");
            var dbPassword = config.properties.getProperty("databasePassword");
            var authenticationDatabase = config.properties.getProperty("authenticationDatabase");
            
            try
            {
	            if (dbUser === null || dbUser.empty || dbPassword === null || dbPassword.empty)
	            {
		           // Try to connect without credentials
					mongoClient = new MongoClient(new ServerAddress(dbHost, dbPort), options);
	            }
	            else
	            {
	            	var MongoCredential credential = MongoCredential.createCredential(dbUser, authenticationDatabase, dbPassword.toCharArray());
					mongoClient = new MongoClient(new ServerAddress(dbHost, dbPort), Arrays.asList(credential), options);
				}
				database = mongoClient.getDatabase(dbName);
			}
			catch(Exception e)
			{
				println(e.message)
			}
			
			userCollection = database.getCollection("user", User);
			sessionCollection = database.getCollection("session", Session);
			// Empties the session table and create a new one.
			sessionCollection.drop
			sessionCollection = database.getCollection("session", Session);
        }
	}
	
	def addUser(User user) {
		try
		{
			userCollection.insertOne(user);
			return true;
		}
		catch(Exception e)
		{
			println(e.message);
			return false;	
		}
	}
	
	def getDatabase() {
		return database;
	}
	
	def getUserByUsername(String username) {
		return database.getCollection("user", User).find(Filters.eq("username", username)).first
	}
	
	def getUserBySessionID(String sessionID) {
		var session = database.getCollection("session", Session).find(Filters.eq("sessionID", sessionID)).first
		if (session === null)
		{
			return null;
		}
		return database.getCollection("user", User).find(Filters.eq("_id", session.userID)).first
	}
		
	def addSession(Session session) {
		try
		{
			sessionCollection.insertOne(session);
			return true;
		}
		catch(Exception e)
		{
			println(e.message);
			return false;	
		}
	}
	
	def removeSession(String sessionID) {
		try
		{
			return database.getCollection("session", Session).deleteOne(Filters.eq("sessionID", sessionID))
		}
		catch(Exception e)
		{
			println(e.message);
			return false;	
		}
	}
	
}
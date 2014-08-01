public with sharing class GameUtil {
	private static String PLAYER_PROFILE = 'Player';

	/*
	*  Returns true if user is assigned to the player profile, meaning he'll be playing the tournament. 
	*  In case this is false, we can assume the user is a referee
	*/
	public static boolean isUserPlaying() {
		Profile profile = [select name from Profile where Id = :UserInfo.getProfileId()][0];
		return profile.name.equalsIgnoreCase(PLAYER_PROFILE);
	}
	/*
	*   Returns the next game scheduled for the user as a player or null in case no games scheduled in the future
	*/
	public static Game__c getNextGameAsPlayer(String userId, Tournament_Edition__c currentEdition) {
		return getRelevantGameAsPlayer(userId, currentEdition, true);
	}
	
	/*
	*   Returns the previous game played by the user or null in case this player hasn't played any games 
	*/
	public static Game__c getPreviousGameAsPlayer(String userId, Tournament_Edition__c currentEdition) {
		return getRelevantGameAsPlayer(userId, currentEdition, false);
	}
	
	private static Game__c getRelevantGameAsPlayer(String userId, Tournament_Edition__c currentEdition, boolean nextGame) {
		Game__c game;
		try {
			Id groupMembershipId = [select id from group_membership__c where team__c in 
								(select team__c from team_membership__c where player__c = :userId and team__r.edition__c=:currentEdition.id) limit 1][0].id;
			try {
				if (nextGame) {
					game = queryNextGameAsPlayer(groupMembershipId);
				} else {
					game = queryPreviousGameAsPlayer(groupMembershipId);
				}
			} catch (ListException e) {
			// swallow in case no previous game
			}
		} catch (ListException e) {
			// in case we're not in any teams this edition
		}
		
		return game;
	}
	
	private static Game__c queryNextGameAsPlayer(Id groupMembershipId) {
		return [select name, home_team_name__c, away_team_name__c from game__c 
					where completed__c = false and when__c > :DateTime.now() and (away_team__c = :groupMembershipId or home_team__c = :groupMembershipId) order by when__c asc limit 1][0];
	}
	
	private static Game__c queryPreviousGameAsPlayer(Id groupMembershipId) {
		return [select name, home_team_name__c, away_team_name__c from game__c 
					where completed__c = true and (away_team__c = :groupMembershipId or home_team__c = :groupMembershipId) order by when__c desc limit 1][0];
	}
	
	/*
	*   Returns the next game scheduled for the referee user or null in case no games scheduled in the future
	*/
	public static Game__c getNextGameAsRef(String userId, Tournament_Edition__c currentEdition) {
		return getRelevantGameAsRef(userId, currentEdition, true);
	}
	
	/*
	*   Returns the previous game scheduled for the referee user or null in case no games were refereeed by this user
	*/
	public static Game__c getPreviousGameAsRef(String userId, Tournament_Edition__c currentEdition) {
		return getRelevantGameAsRef(userId, currentEdition, false);
	}
	
	private static Game__c getRelevantGameAsRef(String userId, Tournament_Edition__c currentEdition, boolean nextGame) {
		Game__c game;
		try {
			try {
				if (nextGame) {
					game = queryNextGameAsRef(userId, currentEdition);
				} else {
					game = queryPreviousGameAsRef(userId, currentEdition);
				}
			} catch (ListException e) {
			// swallow in case no previous game
			}
		} catch (ListException e) {
			// in case we're not in any teams this edition
		}
		
		return game;
	}
	
	private static Game__c queryNextGameAsRef(String userId, Tournament_Edition__c edition) {
		return [select name, home_team_name__c, away_team_name__c from game__c 
					where completed__c = false and when__c > :DateTime.now() and referee__c = :userId and group__r.tournament_edition__c=:edition.id order by when__c asc limit 1][0];
	}
	
	private static Game__c queryPreviousGameAsRef(String userId, Tournament_Edition__c edition) {
		return [select name, home_team_name__c, away_team_name__c from game__c 
					where completed__c = true and referee__c =:userId and group__r.tournament_edition__c=:edition.id order by when__c desc limit 1][0];
	}
	
    public static String getGroupId(String userId, Tournament_Edition__c currentEdition) {	
			Id groupMembershipId = [select id from group_membership__c where team__c in 
								(select team__c from team_membership__c where player__c = :userId and team__r.edition__c=:currentEdition.id) and group__r.tournament_stage__c = :currentEdition.current_stage__c limit 1][0].id;
			return groupMembershipId;
    }

    public static String getFirstGroupId(Tournament_Edition__c currentEdition) {	
			Id groupMembershipId = [select id from group_membership__c 
			where group__r.tournament_edition__c =:currentEdition.id 
			  and group__r.tournament_stage__c = :currentEdition.current_stage__c order by group__r.name limit 1][0].id;
			return groupMembershipId;
    }
    
    public static Tournament_Edition__c getActiveEdition() {
    	Tournament_Edition__c[] t = [select id, name, current_stage__c from Tournament_Edition__c where active__c = true order by createddate desc];
    	// TODO throw meaningful exception in case of no active tournaments
    	return t[0];
    }
}
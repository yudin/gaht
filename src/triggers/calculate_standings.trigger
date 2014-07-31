trigger calculate_standings on Game__c (after insert, after update) {
	for(Game__c game: Trigger.new) {
		// TODO BULKIFY IT
		String homeTeam = String.valueOf(game.home_team__c).substring(0,15);
		integer wins = [select count() from game__c where completed__c = true and win__c = :homeTeam];
        integer loss = [select count() from game__c where completed__c = true and loss__c = :homeTeam];
		integer ties = [select count() from game__c where completed__c = true and (home_team__c = :homeTeam or away_team__c = :homeTeam) and win__c = ''];
		AggregateResult[] totalHomeGoals = [select sum(home_score__c) from game__c where completed__c = true and home_team__c = :homeTeam ];
		AggregateResult[] totalAwayGoals = [select sum(away_score__c) from game__c where completed__c = true and away_team__c = :homeTeam ];
		AggregateResult[] totalHomeGoalsAgainst = [select sum(away_score__c) from game__c where completed__c = true and home_team__c = :homeTeam ];
		AggregateResult[] totalAwayGoalsAgainst = [select sum(home_score__c) from game__c where completed__c = true and away_team__c = :homeTeam ];
		Group_Membership__c standings = [select wins__c from Group_Membership__c where id = :game.home_team__c];
		standings.wins__c = wins;
		standings.losses__c = loss;
		standings.ties__c = ties;
		integer goals;
		standings.goals_favor__c = 0;
		if(totalHomeGoals.size()>0) {
			goals = totalHomeGoals[0].get('expr0')==null?0:Integer.valueOf(totalHomeGoals[0].get('expr0')); 
			standings.goals_favor__c = standings.goals_favor__c + goals;
		}
		if(totalAwayGoals.size()>0) {
			goals = totalAwayGoals[0].get('expr0')==null?0:Integer.valueOf(totalAwayGoals[0].get('expr0')); 
			standings.goals_favor__c = standings.goals_favor__c + goals;
		}
		standings.goals_against__c = 0;
		if(totalHomeGoalsAgainst.size()>0) {
			goals = totalHomeGoalsAgainst[0].get('expr0')==null?0:Integer.valueOf(totalHomeGoalsAgainst[0].get('expr0')); 
			standings.goals_against__c = standings.goals_against__c + goals;
		}
		if(totalAwayGoalsAgainst.size()>0) {
			goals = totalAwayGoalsAgainst[0].get('expr0')==null?0:Integer.valueOf(totalAwayGoalsAgainst[0].get('expr0')); 
			standings.goals_against__c = standings.goals_against__c + goals;
		}
		update standings;
		
		String awayTeam = String.valueOf(game.away_team__c).substring(0,15);
		wins = [select count() from game__c where completed__c = true and win__c = :awayTeam];
        loss = [select count() from game__c where completed__c = true and loss__c = :awayTeam];
		ties = [select count() from game__c where completed__c = true and (home_team__c = :awayTeam or away_team__c = :awayTeam) and win__c = ''];
		totalHomeGoals = [select sum(home_score__c) from game__c where completed__c = true and home_team__c = :awayTeam ];
		totalAwayGoals = [select sum(away_score__c) from game__c where completed__c = true and away_team__c = :awayTeam ];
		totalHomeGoalsAgainst = [select sum(away_score__c) from game__c where completed__c = true and home_team__c = :awayTeam ];
		totalAwayGoalsAgainst = [select sum(home_score__c) from game__c where completed__c = true and away_team__c = :awayTeam ];
		standings = [select wins__c from Group_Membership__c where id = :game.away_team__c];
		standings.wins__c = wins;
		standings.losses__c = loss;
		standings.ties__c = ties;
		standings.goals_favor__c = 0;
		if(totalHomeGoals.size()>0) {
			goals = totalHomeGoals[0].get('expr0')==null?0:Integer.valueOf(totalHomeGoals[0].get('expr0')); 
			standings.goals_favor__c = standings.goals_favor__c + goals;
		}
		if(totalAwayGoals.size()>0) {
			goals = totalAwayGoals[0].get('expr0')==null?0:Integer.valueOf(totalAwayGoals[0].get('expr0')); 
			standings.goals_favor__c = standings.goals_favor__c + goals;
		}
		standings.goals_against__c = 0;
		if(totalHomeGoalsAgainst.size()>0) {
			goals = totalHomeGoalsAgainst[0].get('expr0')==null?0:Integer.valueOf(totalHomeGoalsAgainst[0].get('expr0')); 
			standings.goals_against__c = standings.goals_against__c + goals;
		}
		if(totalAwayGoalsAgainst.size()>0) {
			goals = totalAwayGoalsAgainst[0].get('expr0')==null?0:Integer.valueOf(totalAwayGoalsAgainst[0].get('expr0')); 
			standings.goals_against__c = standings.goals_against__c + goals;
		}
		update standings;
	}
}
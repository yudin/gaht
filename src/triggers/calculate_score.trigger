trigger calculate_score on Goal__c (after delete, after insert, after undelete, 
after update) {
	List<Goal__c> goals;
	if(Trigger.isDelete) {
		goals = Trigger.old;
	} else {
		goals = Trigger.new;
	}
	for(Goal__c goal: goals) {
		Team_Membership__c goal_scorer = [select id, team__c from team_membership__c where id = :goal.scorer__c];
		system.debug(goal_scorer.team__c);
		integer goal_count = [select count() from goal__c where scorer__r.team__c = :goal_scorer.team__c ];
		Game__c game = [select home_score__c, away_score__c, home_team__r.team__c, away_team__c from game__c where id = :goal.game__c];
		System.debug(game.home_team__r.team__c);
		if(game.home_team__r.team__c==goal_scorer.team__c) {
			game.home_score__c = goal_count;
		} else {
			game.away_score__c = goal_count;
		}
		update game;
	}
}
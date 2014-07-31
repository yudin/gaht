public with sharing class GroupStandingsController {
	public String myGroupId {get;set;}
	public List<Standing> teams {
		get {
			List<Standing> standings = new List<Standing>();
			Group_Membership__c groupId =  [select group__c from Group_Membership__c where id = :myGroupId];
			integer ranking = 1;
			integer sequence = 1;
			Group_Membership__c previous;
			for(Group_Membership__c standing: [select team_name__c, points__c, wins__c, losses__c, ties__c, goals_favor__c, goals_against__c, goal_differential__c 
						from Group_Membership__c where group__c = :groupId.group__c order by points__c desc, goal_differential__c desc, goals_favor__c desc]) {
				if(previous!=null)	{
					sequence++;
					if(previous.points__c!=standing.points__c) {
						ranking = sequence;
					}
				} 
				standings.add(new Standing(standing.team_name__c, ranking, Integer.valueOf(standing.points__c), 
					Integer.valueOf(standing.wins__c), Integer.valueOf(standing.losses__c), Integer.valueOf(standing.ties__c),
					Integer.valueOf(standing.goals_favor__c), Integer.valueOf(standing.goals_against__c)));
				previous = standing;
			}
			return standings;
		}
	}
	public String groupName {
		get {
			return [select group__r.name from group_membership__c where id = :myGroupId].group__r.name;
		}
	}
	
	public class Standing {
		public String name {get;set;}
		public Integer ranking {get; set;}
		public Integer points {get; set;}
		public Integer wins {get; set;}
		public Integer ties {get; set;}
		public Integer losses {get; set;}
		public Integer goals_favor {get; set;}
		public Integer goals_against {get; set;}
		public Standing(String name, Integer ranking, Integer points, Integer wins, Integer losses, Integer ties, Integer favor, Integer against) {
			this.name = name;
			this.ranking = ranking;
			this.points = points;
			this.wins = wins;
			this.ties = ties;
			this.losses = losses;
			this.goals_favor = favor;
			this.goals_against = against;
		}
	}
}
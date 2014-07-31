public with sharing class HomeController {
	private Game__c nextGame, previousGame;
	public HomeController() {
		String currentEdition = '2014';
		if(GameUtil.isUserPlaying()){
			nextGame = GameUtil.getNextGameAsPlayer(UserInfo.getUserId(), currentEdition);
			previousGame = GameUtil.getPreviousGameAsPlayer(UserInfo.getUserId(), currentEdition);
		} else {
			nextGame = GameUtil.getNextGameAsRef(UserInfo.getUserId(), currentEdition);
			previousGame = GameUtil.getPreviousGameAsRef(UserInfo.getUserId(), currentEdition);
		}

		if(GameUtil.isUserPlaying()){
			myGroupId = GameUtil.getGroupId(UserInfo.getUserId(), currentEdition);
		} else {
			myGroupId = GameUtil.getFirstGroupId(currentEdition);
		}
	}

	public String myGroupId {
		get; private set;
	}
	
	public String nextGameHomeTeam {
		get {
			return nextGame==null?null:nextGame.home_team_name__c;
		}
	}
	
	public String nextGameAwayTeam {
		get {
			return nextGame==null?null:nextGame.away_team_name__c;
		}
	}

	public String previousGameHomeTeam {
		get {
			return previousGame==null?null:previousGame.home_team_name__c;
		}
	}
	
	public String previousGameAwayTeam {
		get {
			return previousGame==null?null:previousGame.away_team_name__c;
		}
	}
}
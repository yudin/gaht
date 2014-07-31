public with sharing class GameCastController {

	public GameCastController() {
		homeTeamScore = 0;
		awayTeamScore = 0;
	}
	
	public String homeTeam {
		get {
			return 'Chatty';
		}
	}
	
	public String awayTeam {
		get {
			return 'No Sign-Off';
		}
	}
	public integer homeTeamScore {
		get; private set;
	}
	
	public integer awayTeamScore {
		get; private set; 
	}
	
	public void homeTeamScores() {
		homeTeamScore = homeTeamScore + 1;
	}

	public void awayTeamScores() {
		awayTeamScore = awayTeamScore + 1;
	}
}
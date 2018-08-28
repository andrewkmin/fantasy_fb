# Ethereum Fantasy Football
Hey guys, thanks for checking out my project. First of all, I'm super grateful for the opportunity to learn how to develop dApps and write smart contracts. It's been one heck of a ride.

#### Intro
As you could probably tell, the aim of this dApp is fantasy football. In short, fantasy football is a game that's played that is reflective of real football players' performance in the NFL (National Football League -- American football, for my international friends). At the beginning of a season, you pick players in some order (sometimes arbitrary, other times not) and add them to your team. NFL games occur on a weekly basis. In a typical type of fantasy league, each week, your team of selected players faces off against another team, while each player gains points depending on their performance. The team with more points wins that matchup. This leads to playoffs, etc, and a final winner at the end. Usually, participants will "bet"/stake money at the beginning of the season to incentivize trying to get the best team possible. At the end, when a winner has been declared, sometimes they will get the entire pot. Other times, the winner will get a large portion of the pot, the runner-up will get more than his buy-in, and third-place will receive their money back. Some might call this gambling; others would say it requires skill to do well in fantasy. 

#### Primary User Story
All too often, I've been in a fantasy league in which the commissioner (usually a friend delegated with the task) would be incompetent in managing the league. This would manifest itself in the form of not taking buy-ins from participants and not issuing pay-outs quickly enough. It would be awesome to decentralize this process and make it automated. In my opinion, this is a realistic use case, as Ethereum allows for automated payouts in a rather simple (albeit risky) fashion. 

#### Future Steps
In short, there is a lot of functionality that I was not yet able to implement. These include: the use of oracles (in some sort) to correctly determine the outcome of games (and in turn, the performance of fantasy players); trading players; releasing players; acquiring players. 

On the more technical end, I would've loved to use React/Redux/Drizzle as part of the stack as the application (and its state) got more and more complex. Furthermore, I believe it would've been especially cool to implement fantasy players as ERC-721 tokens; after all, in an isolated fantasy league, no two players are the same and each has their own characteristics and stats. 

Because it would be difficult to test using live data (since the 2018 season hasn't yet started), I look to implement a back-testing method so that you can test matchups based on matchups in weeks of previous NFL seasons.

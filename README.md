# Ethereum Fantasy Football
Hey all, thanks for checking out my project. First of all, I'm super grateful to ConsenSys for the opportunity to learn how to develop dApps and write smart contracts. It's been one heck of a ride, and I'm looking forward to keeping in touch with the fellow devs I met through this program. Decentral eyes, decentral lies, decentralize.

### Set up and run this project
1. Clone this repo (whichever method you prefer).
2. Navigate to directory on local/virtual machine via Terminal/iTerm/etc.
3. Run `ganache-cli -p 7545`; this starts a local instance at port 7545. If you'd like to instantiate at a different port, replace 7545 in both this `ganache-cli` command as well as the `truffle.js` file. Alternatively, open the Ganache GUI, which should start at port 7545 by default. If it does not, open up its settings and change the port accordingly. Keep note of and copy the mnemonic that `ganache-cli` or Ganache GUI generate. 
4. Run `truffle compile` and `truffle migrate`. If necessary, monitor live networks via `truffle networks` and reset them using `truffle networks --clean`. `truffle migrate --reset` is also useful to reset contract setup and migrations.
5. Run `npm run dev` to get a local web interface spun up, likely at `http://localhost:3000` if port 3000 is available on your machine.
6. Log into MetaMask on a compatible browser (I recommend Chrome over Brave or Firefox for a consistent experience). Import account via the mnemonic seed phrase copied in step 3. 
7. Create a new test network: `http://127.0.0.1:7545` -- change the port if you did in other steps.
8. Refresh page.
9. Click the "Buy In" button to allow you to draft other players.
10. Draft players, heed alerts, and watch as your balance runs out. 
11. Run `truffle test` to run the tests that I've written.
If you have any issues running any of these steps, please don't hesitate to contact me via email (andrewmin8@gmail.com).

### Intro
As you could probably tell, the aim of this dApp is fantasy football. In short, fantasy football is a game that's played that is reflective of real football players' performance in the NFL (National Football League -- American football, for my international friends). At the beginning of a season, you pick players in some order (sometimes arbitrary, other times not) and add them to your team. NFL games occur on a weekly basis. In a typical type of fantasy league, each week, your team of selected players faces off against another team, while each player gains points depending on their performance. The team with more points wins that matchup. This leads to playoffs, etc, and a final winner at the end. Usually, participants will "bet"/stake money at the beginning of the season to incentivize trying to get the best team possible. At the end, when a winner has been declared, sometimes they will get the entire pot. Other times, the winner will get a large portion of the pot, the runner-up will get more than his buy-in, and third-place will receive their money back. Some might call this gambling; others would say it requires skill to do well in fantasy. 

### Primary user story
All too often, I've been in a fantasy league in which the commissioner (usually a friend delegated with the task) would be incompetent in managing the league. This would manifest itself in the form of not taking buy-ins from participants and not issuing pay-outs quickly enough. It would be awesome to decentralize this process and make it automated. In my opinion, this is a realistic use case, as Ethereum allows for automated payouts in a rather simple (albeit risky) fashion. 

### Future steps
In short, there is a lot of functionality that I was not yet able to implement. These include: the use of oracles (in some sort) to correctly determine the outcome of games (and in turn, the performance of fantasy players); trading players; releasing players; acquiring players. 

On the more technical end, I would've loved to use React/Redux/Drizzle as part of the stack as the application (and its state) got more and more complex. Using React's `localStorage`, for example, could've saved me the headache of having to make frequent reloads and requests to `web3`. Furthermore, I believe it would've been especially cool to implement fantasy players as ERC-721 tokens (NFTs); after all, in an isolated fantasy league, no two players are the same and each has their own characteristics and stats. 

Because it would be difficult to test using live data (since the 2018 season hasn't yet started), I look to implement a back-testing method so that you can test matchups based on matchups in weeks of previous NFL seasons.

### Notes
Front-end written with jQuery, Boostrap and MaterializeCSS. Future developments will go on a separate branch (per ConsenSys' request). 

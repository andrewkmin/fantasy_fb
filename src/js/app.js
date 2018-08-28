App = {
    web3Provider: null,
    contracts: {},
  
    init: function () {
      // Load players.
      $.getJSON('../players.json', function (data) {
        var petsRow = $('#petsRow');
        var petTemplate = $('#petTemplate');
  
        for (i = 0; i < data.length; i++) {
          petTemplate.find('.panel-title').text(data[i].name);
          petTemplate.find('img').attr('src', data[i].picture);
          petTemplate.find('.player-team').text(data[i].team);
          petTemplate.find('.player-position').text(data[i].position.toUpperCase());
          petTemplate.find('.player-rank').text(data[i]["proj_pos_rank"]);

          var cost = 5 - parseInt(data[i]["proj_pos_rank"]);
          petTemplate.find('.player-cost').text(cost);
          
          var text = "Needs one! Draft me!";
  
          var mod = App.splitString(text, text.length/2);
          var newString = mod[0] + "\n" + mod[1];
  
          petTemplate.find('.pet-owner').text(newString);
          petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

          petTemplate.find('.btn-adopt').attr('data-cost', cost);
  
          petsRow.append(petTemplate.html());
        }
      });
  
      return App.initWeb3();
    },
  
    initWeb3: function () {
      // Is there an injected web3 instance?
      if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
      } else {
        // If no injected web3 instance is detected, fall back to Ganache
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      }
      web3 = new Web3(App.web3Provider);
  
      return App.initContract();
    },
  
    initContract: function () {
      $.getJSON('Draft.json', function (data) {
        // Get the necessary contract artifact file and instantiate it with truffle-contract
        var DraftArtifact = data;
        App.contracts.Draft = TruffleContract(DraftArtifact);
  
        // Set the provider for our contract
        App.contracts.Draft.setProvider(App.web3Provider);
  
        web3.eth.getAccounts(function (error, accounts) {
          if (error) {
            console.log(error);
          }
          var account = accounts[0];
          App.getBalance(account);
        })

        // Use our contract to retrieve and mark the adopted pets
        return App.markDrafted();
      });
  
      return App.bindEvents();
    },
  
    // NOTE: DONE
    bindEvents: function () {
      $(document).on('click', '.btn-adopt', App.handleDraft);
      $(document).on('click', '.btn-buy-in', App.handleBuyIn);
    },
  
    // NOTE: DONE
    markDrafted: function (drafters, account) {
      var draftInstance;
  
      App.contracts.Draft.deployed().then(function (instance) {
        draftInstance = instance;
  
        return draftInstance.getOwners.call();
      }).then(function (owners) {
        for (i = 0; i < owners.length; i++) {
          if (owners[i] !== '0x0000000000000000000000000000000000000000') {
            $('.panel-pet').eq(i).find('button').text('Taken').attr('disabled', true);
            var owner = owners[i];
            var mod = App.splitString(owner, owner.length/2);
            var newString = mod[0] + "\n" + mod[1];
            $('.pet-owner').eq(i).text("Owned!");
          }
        }
      }).catch(function (err) {
        console.log(err.message);
      });
    },

    // NOTE: TO-DO -- function for getting balance
    getBalance: function (account) {
      var draftInstance;
  
      App.contracts.Draft.deployed().then(function (instance) {
        draftInstance = instance;

        console.log('ACCOUNT', account);
        
        // DON'T LET THEM DO ANYTHING UNLESS THEY BUY IN FIRST
        return draftInstance.getBalance(account);
      }).then(function (balance) {
        console.log('BALANCE', balance);

        // this is happening at the wrong time
        $('.btn-buy-in').text('Balance: '+balance).attr('disabled', true);

      }).catch(function (err) {
        console.log(err.message);
      });
    },
  
    splitString: function(value, index) {
      return [value.substring(0, index), value.substring(index)];
    },

    // NOTE; TO-DO
    handleBuyIn: function (event) {
      event.preventDefault();

      var draftInstance;

      web3.eth.getAccounts(function (error, accounts) {
        if (error) {
          console.log(error);
        }
  
        var account = accounts[0];
        console.log('ALL ACCOUNTS', accounts);
  
        App.contracts.Draft.deployed().then(function (instance) {
          draftInstance = instance;
  
          // Execute adopt as a transaction by sending account
          return draftInstance.buyIn({
            from: account,
            value: 100
          });
        }).then(function () {
          alert('You bought in');
          return App.getBalance(account);
        }).catch(function (err) {
          console.log(err.message);
        });
      });
    },
  
    // NOTE: DONE
    handleDraft: function (event) {
      event.preventDefault();
  
      var playerId = parseInt($(event.target).data('id'));
      
      var cost = parseInt($(event.target).data('cost'));
  
      var draftInstance;
  
      web3.eth.getAccounts(function (error, accounts) {
        if (error) {
          console.log(error);
        }
  
        var account = accounts[0];
        console.log('all accounts', accounts);
  
        App.contracts.Draft.deployed().then(function (instance) {
          draftInstance = instance;
  
          // Execute adopt as a transaction by sending account
          return draftInstance.draft(playerId, cost, {
            from: account
          });
        }).then(function (result) {
          alert('You drafted a player. Refresh to note changes.');
          return App.markDrafted();
        }).then(function () {
          return App.getBalance(account);
        }).catch(function (err) {
          console.log(err.message);
        });
      });
    }
  
  };
  
  $(function () {
    $(window).load(function () {
      App.init();
    });
  });
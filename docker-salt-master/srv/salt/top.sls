base:
  'master-minion':
    - git


  #Common for all minions except the master minion
  '* and not master-minion':
    - match: compound
    - git


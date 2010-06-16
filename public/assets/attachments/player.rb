# == Schema Information
#
# Table name: players
#
#  id                      :integer(8)      not null, primary key
#  first_name              :string(100)     not null
#  last_name               :string(100)     not null
#  player_role_id          :integer(4)      not null
#  nationality_id          :integer(4)      not null
#  gender_id               :integer(4)      not null
#  player_status_id        :integer(4)      not null
#  height                  :float           default(1.7)
#  weight                  :float           default(65.0)
#  user_id                 :integer(4)      not null
#  owner                   :integer(4)      default(2)
#  cash                    :integer(4)      default(6000)
#  energy                  :integer(4)      default(100)
#  morale                  :integer(4)      default(100)
#  fame                    :integer(4)      default(0)
#  popularity              :integer(4)      default(0)
#  skill_points            :integer(4)      default(15)
#  training_points         :integer(4)      default(10)
#  player_career_status_id :integer(2)      default(2), not null
#  player_permission_id    :integer(4)
#

class Player < ActiveRecord::Base

  belongs_to :user
  belongs_to :gender
  belongs_to :nationality
  belongs_to :player_role
  belongs_to :player_career_status

  belongs_to :owner_user, :class_name => 'User', :foreign_key => 'owner'

  has_many :player_atbs, :include => :atb
  has_many :atbs, :through => :player_atbs

  has_many :team_player_histories, :order => "start_date_time DESC"
  has_many :teams, :through => :team_player_histories
  has_many :player_contract_bills

  has_many :contracts, :order => "created_at DESC"

  has_many :web_game_player_stats, :order => "web_game_player_stats_type_id ASC"#, :include => :web_game_player_stats_type
  has_many :web_season_player_stats, :order => "web_season_player_stats_type_id ASC", :include => :web_season_player_stats_type
  has_many :game_team_players
  has_many :starting_elevens

  validates_presence_of :first_name, :last_name, :nationality_id, :gender_id, :player_role_id, :only => [:create,:new]
  validate_on_create :full_name_is_unique

  before_validation :setup_defaults
  #after_create :increment_player_demand #move to trigger

  has_one :player_permission


  CONTRACT_STATUS_ACCEPTED = 1


  # get current team
  def current_team
    contract = self.contracts.find_by_contract_status_id CONTRACT_STATUS_ACCEPTED
    if contract.nil?
      nil
    else
      contract.team
    end
  end

  def get_attribute_value(name)
    a = player_atbs.first :conditions => {"atbs.atb_name" => name}
    a.skill_point
  end

  def set_attribute_value(name, value)
    a = player_atbs.first :conditions => {"atbs.atb_name" => name}
    a.skill_point = value
    a.save
  end

  # a bit fugly, but didn't know what to call the helper

  def increment_player_demand
    PlayerCareerStatus.find_by_name("active").increment!(:num_players)
    player_role.increment!(:demand)

    # initialize player's atbs
      Atb.all.each do |atb|
        PlayerAtb.create :player_id => self.id, :atb_id => atb.id, :skill_point => rand(50) + 1, :training_progress => rand(40) + 1
      end
  end

  def full_name_is_unique
    player = Player.find_by_first_name_and_last_name(first_name, last_name)
    if player
      errors.add_to_base("Player already exists!")
    end
  end

  def self.update_players_attr_by_event(event)
    case event
    when :game
      self.all.each do |player|
        player.fame += 1
        player.popularity += 1
        player.save
      end
    end
  end

  def update_player_attr_by_event(event, values=nil)
    case event
    when :game
      self.fame += 1
      self.popularity += 1

    when :contract_accepting
      #self.cash += values[:offer].contract_details.newest.first.signing_bonus
      #insert to team_bonus_finance will have a trigger to add/subtract cash for player/team
      ct = values[:offer]
      #this is finance bonus, don't count other bonus
      #after match finish, insert new record in to this table
      TeamBonusFinance.create({
        :player_id => ct.player_id,
        :team_id => ct.team_id,
        :contract_id => ct.id,
        :signing_bonus => ct.contract_details.newest.first.signing_bonus,
        :description => "Signing Bonus"
      })
    when :assign_skill_points

    when :retirement
      self.player_career_status_id = 3
      self.owner = 0
    end

    self.save
  end

  def current_contract
    contracts.find_by_contract_status_id CONTRACT_STATUS_ACCEPTED
  end

  def can_retire?
    (current_contract && (current_contract.contract_details.first.contract_length < Time.now)) || current_contract.nil?
  end

  PLAYER_CAREER_STATUS_ACTIVE = 2
  def retire
    if can_retire?
      self.player_career_status_id = 3
      self.owner = 0

      self.leave
      self.expire_contract

      self.player_role.demand -= 1
      self.player_role.save

      self.save

      pcs = PlayerCareerStatus.find(PLAYER_CAREER_STATUS_ACTIVE)
      pcs.num_players -= 1
      pcs.save
    end
  end

  def self.create_new_player(args = nil)
    # initialize player's height & weight
    Player.transaction do
      pcs = PlayerCareerStatus.find_by_name "active"
      pcs.num_players += 1
      pcs.save

      player_active_status = PlayerStatus.find_by_status_name("Active")
      args.merge!( {:height => rand(20) + rand(100).to_f/100,
                    :weight => rand(300) + rand(100).to_f/100,
                    :player_status_id => player_active_status.id,
                    :player_career_status_id => pcs.id} )

      p = Player.create(args)

      p.player_role.demand += 1
      p.player_role.save
      return p
    end
  end

  def leave
    # create new cpu player
    unless current_contract.nil?
      args = {  :first_name => "Hero",
                :last_name => "CPU #{Player.last.id + 1}",
                :player_role_id => self.player_role_id,
                :nationality_id => self.nationality_id,
                :gender_id => self.gender_id,
                :player_status_id => 1,
                :user_id => 2,
                :owner => 2,
                :player_career_status_id => 2
             }
      p = Player.create_new_player(args)

      # replace this player by new cpu player
      # - sign new contract
      #
      args = { :team_id => current_contract.team_id }
      p.sign_contract(args)
    end
  end

  def sign_contract(args=nil)
    args.merge!( { :player_id => self.id,
                   :start_date_time => Time.now
                } )
    TeamPlayerHistory.create(args)
  end

  def expire_contract
    contract = self.team_player_histories.find_by_end_date_time nil
    unless contract.nil?
      contract.end_date_time = contract.start_date_time - 1 # "rejected"
      contract.save
    end
  end

  #method to be used for background tasks
  def increase_energy(increment)
    update_attribute(:energy, self.energy + increment)
  end
  def decrease_energy(increment)
    update_attribute(:energy, self.energy - increment)
  end

  def increase_morale(increment)
    update_attribute(:morale, self.energy + increment)
  end
  def decrease_morale(increment)
    update_attribute(:morale, self.energy - increment)
  end

  def increase_fame(increment)
    update_attribute(:fame, self.fame + increment)
  end
  def decrease_fame(increment)
    update_attribute(:fame, self.fame - increment)
  end

  def increase_popularity(increment)
    update_attribute(:popularity, self.popularity + increment)
  end
  def decrease_morale(increment)
    update_attribute(:popularity, self.popularity - increment)
  end

  def self.update_energy_to_all_players_daily
    Player.all.each do |player|
      p.increase_energy(20 + p.get_attribute_value("Stamina"))
    end
  end

  # --------------
  # tactics
  #has_many :player_tactics
  def player_tactics
    PlayerTactic.find_all_by_player_id(self.id)
  end

  def player_tactic(tactic)
    #pt = PlayerTactic.new_or_return_player_tactic(self, tactic)
    PlayerTactic.get_player_tactic(self, tactic)
  end
  def get_player_tactic_value(tactic)
    pt = PlayerTactic.get_player_tactic(self, tactic)
    pt.tactics_value
  end
  def set_player_tactic(tactic, value)
    pt = PlayerTactic.get_player_tactic(self, tactic)
    pt.tactics_value = value
    pt.save
  end
  # tactics
  # --------------

  # TRUONG
  def position_string
    self.player_role.description
  end

  def get_position_image
    case self.player_role.description
      when "CF"
        return '<img width="41" height="15" src="/images/position/pos-cf.png" alt="CF"/>'
      when "F"
        return '<img width="41" height="15" src="/images/position/pos-f.png" alt="F"/>'
      when "LW"
        return '<img width="41" height="15" src="/images/position/pos-lw.png" alt="LW"/>'
      when "RW"
        return '<img width="41" height="15" src="/images/position/pos-cf.png" alt="RW"/>'
      when "SS"
        return '<img width="41" height="15" src="/images/position/pos-ss.png" alt="SS"/>'
      when "AM"
        return '<img width="41" height="15" src="/images/position/pos-am.png" alt="AM"/>'
      when "LM"
        return '<img width="41" height="15" src="/images/position/pos-lm.png" alt="LM"/>'
      when "RM"
        return '<img width="41" height="15" src="/images/position/pos-rm.png" alt="RM"/>'
      when "CM"
        return '<img width="41" height="15" src="/images/position/pos-cm.png" alt="CM"/>'
      when "DM"
        return '<img width="41" height="15" src="/images/position/pos-dm.png" alt="DM"/>'
      when "W"
        return '<img width="41" height="15" src="/images/position/pos-w.png" alt="W"/>'
      when "LWB"
        return '<img width="41" height="15" src="/images/position/pos-lwb.png" alt="LWB"/>'
      when "RWB"
        return '<img width="41" height="15" src="/images/position/pos-rwb.png" alt="RWB"/>'
      when "FB"
        return '<img width="41" height="15" src="/images/position/pos-fb.png" alt="FB"/>'
      when "LB"
        return '<img width="41" height="15" src="/images/position/pos-lb.png" alt="LB"/>'
      when "RB"
        return '<img width="41" height="15" src="/images/position/pos-rb.png" alt="RB"/>'
      when "CB"
        return '<img width="41" height="15" src="/images/position/pos-cb.png" alt="CB"/>'
      when "SW"
        return '<img width="41" height="15" src="/images/position/pos-sw.png" alt="SW"/>'
      when "GK"
        return '<img width="41" height="15" src="/images/position/pos-gk.png" alt="GK"/>'
    end
  end

  def get_energy_status
    if self.energy >= 50
      return "<span style='color:#D9E021'>#{self.energy}%</span>"
    else
      return "<span style='color:#850000'>#{self.energy}%</span>"
    end
  end

  def morale_level_string
    if self.morale >= 90
      'Excellent'
    elsif self.morale >= 80 and self.morale < 90
      'Good'
    elsif self.morale >= 70 and self.morale < 80
      'OK'
    elsif self.morale >= 60 and self.morale < 70
      'Poor'
    else
      'Very Poor'
    end
  end

  def get_morale_status
    if self.morale >= 90
      return '<span><img width="12" height="15" src="/images/morale/excellent.png" alt="GK"/></span> Excellent'
    elsif self.morale >= 80 and self.morale < 90
      return '<span><img width="12" height="12" src="/images/morale/good.png" alt="GK"/></span> Good'
    elsif self.morale >= 70 and self.morale < 80
      return '<span><img width="15" height="12" src="/images/morale/ok.png" alt="GK"/></span> OK'
    elsif self.morale >= 60 and self.morale < 70
      return '<span><img width="12" height="12" src="/images/morale/poor.png" alt="GK"/></span> Poor'
    elsif self.morale < 60
      return '<span><img width="12" height="15" src="/images/morale/vpoor.png" alt="GK"/></span> Very Poor'
    end
  end

  def get_morale_status_image
    if self.morale >= 90
      return '<img width="12" height="15" src="/images/morale/excellent.png" alt="GK"/>'
    elsif self.morale >= 80 and self.morale < 90
      return '<img width="12" height="12" src="/images/morale/good.png" alt="GK"/>'
    elsif self.morale >= 70 and self.morale < 80
      return '<img width="15" height="12" src="/images/morale/ok.png" alt="GK"/>'
    elsif self.morale >= 60 and self.morale < 70
      return '<img width="12" height="12" src="/images/morale/poor.png" alt="GK"/>'
    elsif self.morale < 60
      return '<img width="12" height="15" src="/images/morale/vpoor.png" alt="GK"/>'
    end
  end

  def get_stats(stat_type)
    WebGamePlayerStat.find(:all, :conditions => {})
  end

  def owned_by?(user)
    self.owner == user.id
  end

  def created_by?(user)
    self.user_id == user.id
  end
  # --------------

  def name
    "#{self.first_name} #{self.last_name}"
  end

  # ---------------------------------
  # scout ---------------------------

  #TODO implement these

  belongs_to :player_permission

  SCOUTING_LEVEL_0 = 0
  SCOUTING_LEVEL_1 = 1
  SCOUTING_LEVEL_2 = 2
  SCOUTING_LEVEL_3 = 3
  SCOUTING_LEVEL_4 = 4

  # examine scouting level of a user over this player
  # return 0-4
  # 0-3 are scouting level
  # 4 show full info
  def scouting_level(user)
    unless current_team.nil?
      team = current_team
      permission = player_permission.try(:name) || PlayerPermission::PERMISSION_TEAM_OWNER_CAN_VIEW_ENTIRE_PROFILE
      is_level_4 = case permission
        when PlayerPermission::PERMISSION_HIDE_ATTRIBUTES_FROM_EVERYONE
          false
        when PlayerPermission::PERMISSION_TEAM_OWNER_CAN_VIEW_ENTIRE_PROFILE
          current_team.owner_user == user
        when PlayerPermission::PERMISSION_TEAM_OWNER_AND_STAFF_CAN_VIEW_ENTIRE_PROFILE
          current_team.owner_user == user or team.staff_users.include?(user)
        when PlayerPermission::PERMISSION_ALL_TEAM_MEMBERS_AND_STAFF_CAN_VIEW_ENTIRE_PROFILE
          owner_user == user or team.staff_users.include?(user)  #TODO revise!!!
        when PlayerPermission::PERMISSION_EVERYONE_CAN_VIEW_ENTIRE_PROFILE
          true
      end
      return SCOUTING_LEVEL_4 if is_level_4

      current_team.scout_level_from_user(user)
    else #else of unless
      if self.owner == user.id
        SCOUTING_LEVEL_4 #owner
      else
        SCOUTING_LEVEL_0 #not belong to any team
      end
    end
  end


  #TODO improve
  def current_team
    team_history = self.team_player_histories.first
    team_history && team_history.end_date_time.nil? ? team_history.team : nil
  end

  # scout ---------------------------
  # ---------------------------------

  def self.framed_statistics_xml(game_id, player_id, time_frame)
    builder = Builder::XmlMarkup.new #("", 2)
    builder.instruct!

    stat_str = "goals:1|assits:0|shots on target:5/10|distance run:4km"
    builder.player_staticstics(:player_id => player_id, :time_frame => time_frame) do
      builder.player_staticstics_string stat_str
    end
  end

  def training(regimen, breakthroughs = false)
    TrainingRegimen.find_by_regimen_name(regimen).training_reg_affected_atbs.each do |reg_aff_atb|
      pa = PlayerAtb.find :first, :conditions => ["player_id = ? AND atb_id = ?", self.id, reg_aff_atb.atb_id]
      normal_training_pct = get_increase_percentage(pa.skill_point,breakthroughs)
      pa.skill_point += pa.skill_point * normal_training_pct / 100
      pa.skill_point = 100 if pa.skill_point > 100
      pa.save
    end

    self.energy = (self.energy + 10 > 100) ? 100 : self.energy + 10
    self.morale = (self.morale + 5 > 100) ? 100 : self.morale + 5
    self.cash -= 120
    self.training_points -= 2
    self.save
  end

  ACTIVITY_REST = 1
  ACTIVITY_NIGHT_ON_THE_TOWN = 2
  REGIMEN_OUT_WITH_FRIENDS = 1
  REGIMEN_PARTY = 2
  REGIMEN_HARD_PARTY = 3
  def activity_training(activity, regimen)
    self.training_points -= 1

    if activity == ACTIVITY_NIGHT_ON_THE_TOWN
      case regimen
        when REGIMEN_OUT_WITH_FRIENDS
          self.cash -= 100
          self.morale = self.morale + 5 > 100 ? 100 : self.morale + 5
          self.energy = self.energy + 10 > 100 ? 100 : self.energy + 10
        when REGIMEN_PARTY
          self.cash -= 1000
          self.morale = self.morale + 10 > 100 ? 100 : self.morale + 10
        else # REGIMEN_HARD_PARTY
          self.cash -= 5000
          self.morale = self.morale + 10 > 100 ? 100 : self.morale + 10
          self.fame += 1
      end
    end

    self.save
  end

  # give 3 contract offers from 3 cpu teams for newly created player
  def cpu_offers_for_new_player(player_owner)
    allteams = Team.all
    l = allteams.length - 1

    teams = []
    if l > 2
      t1 = (rand(l) + l) / 2
      t2 = rand(t1)
      t3 = t1 + 1 + rand(l - t1)
      teams << allteams[t1] << allteams[t2] << allteams[t3]
    else
      for i in 1..l
        teams << allteams[i-1]
      end
    end

    #init season
    #TODO: choose correct season
    season = Season.last
    teams.each do |team|
      contract = Contract.create :player_id => self.id, :team_id => team.id, :contract_status_id => 4,:accept_negotiate => false
      contract.contract_details.create({
        :season_id => season.id,
        :daily_wages => 1000,
        :signing_bonus => 1000,
        :contract_length => season.end_date_time,
        :appearance_fee => 0,
        :goal_bonus => 0,
        :assist_bonus => 0,
        :clean_sheet_bonus => 0,
        :fee_release_clause => 0,
        :relegation_release_clause => 0,
        :accept_loan_move => 0
      })

      # alert contract offer message
      Alert.alert_contract_offer(User.cpu_user, player_owner, self, team)
    end
  end


  def accept_contract(contract)
      TeamBonusFinance.create({
        :player_id => contract.player_id,
        :team_id => contract.team_id,
        :contract_id => contract.id,
        :signing_bonus => contract.contract_details.newest.first.signing_bonus,
        :description => "Signing Bonus"
      })
  end

  def update_shirt_number(team_id)
    team = Team.find team_id
    self.update_attributes :shirt_number => team.players.maximum('shirt_number') + 1
  end


  private

  def get_increase_percentage(skill_point,breakthroughs)
    #breakthroughs: return 25%
    if breakthroughs
      25
    else
      if skill_point < 60
        1
      elsif skill_point >= 60 && skill_point < 65
        5
      elsif skill_point >= 65 && skill_point < 70
        4
      elsif skill_point >= 70 && skill_point < 75
        3
      elsif skill_point >= 75 && skill_point < 80
        2
      elsif skill_point >= 80
        1
      end
    end
  end

  def setup_defaults
    self.height ||= rand(20) + rand(100).to_f/100
    self.weight ||= rand(300) + rand(100).to_f/100
    self.player_status_id ||= PlayerStatus.find_by_status_name("Active").id
    self.player_career_status_id ||= PlayerCareerStatus.find_by_name("active").id
  end

  ATB_GROUP_PHYSICAL = 1
  ATB_GROUP_FOOTBALL = 2
  ATB_GROUP_MENTAL = 3
  NORMAL_ATB_GROUP = [ATB_GROUP_PHYSICAL, ATB_GROUP_FOOTBALL, ATB_GROUP_MENTAL]
  PRIMARY_ATB_RANGE = 10
  SECONDARY_ATB_RANGE = 5
  UNRELEVANT_ATB_RANGE = 2
  BASE_SKILL_POINT = 10
  def reroll 

  REPEAT
    FETCH cur1 INTO this_atb_id, this_atb_group_id, this_is_primary;
    IF NOT done THEN
       IF this_is_primary = 1 THEN
          SET distributed_points = FLOOR( RAND() * (primary_atb_range + 1));
       ELSEIF this_is_primary = 0 THEN
          SET distributed_points = FLOOR( RAND() * (secondary_atb_range + 1));
       ELSE
          SET distributed_points = FLOOR( RAND() * (unrelevant_atb_range + 1));
       END IF;

        IF this_atb_group_id = atb_group_physical OR this_atb_group_id = atb_group_football OR this_atb_group_id = atb_group_mental THEN 
          IF total_distributed_points >= distributed_points THEN 
            SET total_distributed_points = total_distributed_points - distributed_points; 
          ELSE 
            SET distributed_points = total_distributed_points;
            SET total_distributed_points = 0; 
          END IF;
   
          SET base_point = base_skill_point;  

        ELSE
          SET distributed_points = 0;
          SET base_point = 0; 
        END IF;

        INSERT INTO player_atbs(`player_id`,`atb_id`,`skill_point`,`training_progress`) VALUES (this_player_id, this_atb_id, distributed_points + base_point, default_training_progress);

    END IF;
  UNTIL done END REPEAT;
  
  
    total_distributed_points = 65
    
    self.player_atbs.each do |pa|
      if NORMAL_ATB_GROUP.include? pa.atb.atb_group_id
        is_primary = PrimarySecondaryAtb.find :conditions => ["player_role_id = ? AND atb_id = ?", self.player_role_id, pa.atb_id]
         = 10
  SECONDARY_ATB_RANGE = 5
  UNRELEVANT_ATB_RANGE = 2
        if is_primary.primary == 1 
          distributed_points = rand(PRIMARY_ATB_RANGE + 1)         
        else
        
        end       
      end 
    end 
  end 
end


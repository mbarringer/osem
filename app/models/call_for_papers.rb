class CallForPapers < ActiveRecord::Base
  attr_accessible :start_date, :end_date,
                  :description, :schedule_changes, :rating,
                  :schedule_public, :include_cfp_in_splash, :conference_id
  belongs_to :conference

  validates_presence_of :start_date, :end_date
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  ##
  # Calculates how many weeks the call for paper is.
  #
  # ====Returns
  # * +Integer+ -> start week
  def weeks
    result = end_week - start_week + 1
    weeks = Date.new(start_date.year, 12, 31).strftime('%W').to_i
    result < 0 ? result + weeks : result
  end

  ##
  # Calculates the end week of the cfp
  #
  # ====Returns
  def start_week
    start_date.strftime('%W').to_i
  end

  ##
  # Calculates the end week of the cfp
  #
  # ====Returns
  def end_week
    end_date.strftime('%W').to_i
  end

  ##
  # Checks whether cfp dates is updated
  #
  # ====Returns
  # * +True+ -> If cfp dates is updated and all other parameters are set
  # * +False+ -> Either cfp date is not updated or one or more parameter is not set
  def notify_on_cfp_date_update?
    !self.end_date.blank? && !self.start_date.blank?\
    && (self.start_date_changed? || self.end_date_changed?)\
    && self.conference.email_settings.send_on_call_for_papers_dates_updates\
    && !self.conference.email_settings.call_for_papers_dates_updates_subject.blank?\
    && !self.conference.email_settings.call_for_papers_dates_updates_template.blank?
  end
  ##
  # Checks whether cfp dates is updated
  #
  # ====Returns
  # * +True+ -> If cfp dates is updated and all other parameters are set
  # * +False+ -> Either cfp date is not updated or one or more parameter is not set
  def notify_on_schedule_public?
    !self.end_date.blank? && !self.start_date.blank?\
    && (self.start_date_changed? || self.end_date_changed?)\
    && self.conference.email_settings.send_on_call_for_papers_dates_updates\
    && !self.conference.email_settings.call_for_papers_dates_updates_subject.blank?\
    && !self.conference.email_settings.call_for_papers_dates_updates_template.blank?
  end
end

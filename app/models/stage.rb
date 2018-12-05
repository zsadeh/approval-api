# Insights Service Approval APIs
#
# APIs to query approval service
#
# OpenAPI spec version: 1.0.0
#
# Generated by: https://github.com/swagger-api/swagger-codegen.git
#

class Stage < ApplicationRecord
  include ApprovalStates
  include ApprovalDecisions

  acts_as_tenant(:tenant)

  has_many :actions, :dependent => :destroy

  belongs_to :group
  belongs_to :request

  validates :state,    :inclusion => { :in => STATES }
  validates :decision, :inclusion => { :in => DECISIONS }
end

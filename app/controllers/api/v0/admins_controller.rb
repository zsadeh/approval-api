# Insights Service Approval APIs
#
# APIs to query approval service
#
# OpenAPI spec version: 1.0.0
#
# Generated by: https://github.com/swagger-api/swagger-codegen.git
#
module Api
  module V0
    class AdminsController < ApplicationController
      include UserOperationsMixin
      include ApproverOperationsMixin

      def add_approver
        approver = Approver.create!(approver_params)
        json_response(approver, :created)
      end

      def add_group
        group = Group.create!(group_params)
        json_response(group, :created)
      end

      def add_workflow
        workflow = WorkflowCreateService.new(params.require(:template_id)).create(workflow_params)
        json_response(workflow, :created)
      rescue ActiveRecord::RecordNotFound => e
        json_response({ :message => e.message }, :unprocessable_entity)
      end

      def add_action_by_request_id
        # TODO
      end

      def fetch_approvers_by_group_id
        group = Group.find(params.require(:group_id))
        json_response(group.approvers)
      end

      def fetch_approver_by_id
        approver = Approver.find(params.require(:id))
        json_response(approver)
      end

      def fetch_approvers
        approvers = Approver.all

        json_response(approvers)
      end

      def fetch_group_by_id
        group = Group.find(params.require(:id))

        json_response(group)
      end

      def fetch_groups
        groups = Group.all

        json_response(groups)
      end

      def fetch_groups_by_approver_id
        approver = Approver.find(params.require(:id))
        groups = approver.groups

        json_response(groups)
      end

      def fetch_requests_by_approver_id
        approver = Approver.find(params.require(:id))
        requests = approver.requests

        json_response(requests)
      end

      def fetch_requests
        reqs = Request.filter(params.slice(:requester, :decision, :state))

        json_response(reqs)
      end

      def fetch_stages
        stages = Stage.all

        json_response(stages)
      end

      def fetch_template_by_id
        template = Template.find(params.require(:id))
        json_response(template)
      end

      def fetch_template_workflows
        template = Template.find(params.require(:template_id))
        json_response(template.workflows)
      end

      def fetch_templates
        templates = Template.all
        json_response(templates)
      end

      def fetch_workflow_by_id
        workflow = Workflow.find(params.require(:id))

        json_response(workflow)
      end

      def fetch_workflow_requests
        workflow = Workflow.find(params.require(:workflow_id))

        json_response(workflow.requests)
      end

      def fetch_workflows
        workflows = Workflow.all

        json_response(workflows)
      end

      def group_operation
        GroupOperationService.new(params.require(:id)).operate(params.require(:operation), params.require(:parameters))

        head :no_content
      rescue StandardError => e
        json_response({ :message => "#{e.message}" }, :forbidden)
      end

      def remove_approver
        Approver.find(params.require(:id)).destroy
        head :no_content
      end

      def remove_group
        Group.find(params.require(:id)).destroy
        head :no_content
      end

      def remove_workflow
        Workflow.find(params.require(:id)).destroy

        head :no_content
      end

      def update_approver
        Approver.find(params.require(:id)).update(approver_params)
        head :no_content
      end

      def update_group
        Group.find(params.require(:id)).update(group_params)
        head :no_content
      end

      def update_workflow
        Workflow.find(params.require(:id)).update(workflow_params)

        head :no_content
      end

      private

      def approver_params
        params.permit(:email, :first_name, :last_name, :group_ids => [])
      end

      def group_params
        params.permit(:name, :approver_ids => [])
      end

      def stage_params
        params.permit(:state, :decision, :comments, :group_id)
      end

      def template_params
        params.permit(:title, :description)
      end

      def workflow_params
        params.permit(:name, :description, :group_ids => [])
      end
    end
  end
end

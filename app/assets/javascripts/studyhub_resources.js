var SR = {

    removetitleRow: function () {
        var row = $j(this).parents('.resource-title');
        row.remove();
    },

    removedescriptionRow: function () {
        var row = $j(this).parents('.resource-description');
        row.remove();
    },

    removeIDRow: function () {
        var row = $j(this).parents('.id-id');
        row.remove();
    },

    removeRoleRow: function () {
        var row = $j(this).parents('.resource-role');
        row.remove();
    },


    addCalendar: function () {
        var showTime = $j(this).data('calendar') === 'mixed';
        $j(this).datetimepicker({
            format: showTime ? 'YYYY-MM-DD HH:mm' : 'YYYY-MM-DD',
            sideBySide: showTime
        });
    },


    intialResourceUseRightVisibility: function () {


         $j('input[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_description]"]').parent().hide();
         $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_1]"]').parent().hide();
         $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_2]"]').parent().hide();
         $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_3]"]').parent().hide();

    },

    setResourceUseRightVisibility: function () {

        check_license = $j(this).val();


            if (! (check_license == "N/A")) {

                $j('input[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_description]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_1]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_2]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_3]"]').parent().show();

            }else{

                $j('input[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_description]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_1]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_2]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation_3]"]').parent().hide();
            }
    },

    intialStudyDataSharingPlanVisibility: function () {
        if (!$j('select[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_generally]"]').val().startsWith("Yes")){
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_supporting_information]"]').hide();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_time_frame]"]').parent().hide();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_access_criteria]"]').parent().hide();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_url]"]').parent().hide();
        }
    },

    setStudyDataSharingPlanVisibility: function () {

        plan = $j(this).val();
        if (plan.startsWith("Yes")) {
             $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_supporting_information]"]').show();
             $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_time_frame]"]').parent().show();
             $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_access_criteria]"]').parent().show();
             $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_url]"]').parent().show();
        }else{

            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_supporting_information]"]').hide();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_time_frame]"]').parent().hide();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_access_criteria]"]').parent().hide();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_url]"]').parent().hide();
        }
    },

    intialStudyPrimaryDesignVisibility: function () {

        //interventional study design
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_phase]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]').parent().hide();

        //study_masking_roles (multiselect)
        $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_masking_description]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_allocation]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_control]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_off_label_use]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_description]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_title]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_description]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_time_frame]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_title]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_description]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_time_frame]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_title]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_description]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_time_frame]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_type]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_name]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_description]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_arm_group_label]"]').parent().hide();


        //non interventional study design
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_time_perspective]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_target_follow-up_duration]"]').parent().hide();

    },

    setStudyPrimaryDesignVisibility: function () {

        design = $j(this).val();
        switch (design){
            case 'interventional':

                //show interventional
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().show();

                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_phase]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]').parent().show();

                //study_masking_roles (multiselect)
                $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_masking_description]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_allocation]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_control]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_off_label_use]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_description]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_title]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_description]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_time_frame]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_title]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_description]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_time_frame]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_title]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_description]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_time_frame]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_type]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_name]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_description]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_arm_group_label]"]').parent().show();


                //hide non interventional
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_time_perspective]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_target_follow-up_duration]"]').parent().hide();

                break;


            case 'non-interventional':

                //hide interventional
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_phase]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]').parent().hide();
                $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_masking_description]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_allocation]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_control]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_off_label_use]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_title]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_time_frame]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_title]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_time_frame]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_title]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_time_frame]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_type]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_name]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_arm_group_label]"]').parent().hide();



                //show non interventional
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_time_perspective]"]').parent().show();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_target_follow-up_duration]"]').parent().show();
                break;

            default:

                //interventional study design
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_phase]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]').parent().hide();

                //study_masking_roles (multiselect)
                $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_masking_description]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_allocation]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_control]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_off_label_use]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_title]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_primary_outcome_time_frame]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_title]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_secondary_outcome_time_frame]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_title]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_other_prespecified_outcome_measures_time_frame]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_type]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_name]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_description]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_intervention_arm_group_label]"]').parent().hide();


                //non interventional study design
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_time_perspective]"]').parent().hide();
                $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_target_follow-up_duration]"]').parent().hide();
        }
    }

};

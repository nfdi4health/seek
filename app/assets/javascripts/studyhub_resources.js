var SR = {

    removetitleRow: function () {
        var row = $j(this).parents('.resource-title');
        row.remove();
    },

    removeacronymRow: function () {
        var row = $j(this).parents('.resource-acronym');
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
        check_license = $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_label]"]').val();
        if (check_license.startsWith('CC')) {
            $j('select[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').prev().addClass('submit-required');
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').prev().addClass('submit-required');
        }
    },

    setResourceUseRightVisibility: function () {
        check_license = $j(this).val();
        if (check_license.startsWith('CC')) {
           $j('select[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').prev().addClass('submit-required');
           $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').prev().addClass('submit-required');

        }
        else{
            $j('select[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').prev().removeClass('submit-required');
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').prev().removeClass('submit-required');
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

        study_type = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();

        switch (study_type){
            case 'Interventional':
                $j('div[id="study_design_interventional"]').parent().parent().show();
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                $j('button[id="study_primary_design_next_button"]').removeClass('hidden');
                break;

            case 'Non-interventional':
                $j('div[id="study_design_non_interventional"]').parent().parent().show();
                $j('div[id="study_design_interventional"]').parent().parent().hide();
                $j('button[id="study_primary_design_next_button"]').removeClass('hidden');
                $j('button[id="study_primary_design_next_button"]').attr('onclick','toggle(\'study_design_non_interventional\')');
                break;
            default:
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                $j('div[id="study_design_interventional"]').parent().parent().hide();

        }

    },

    setStudyPrimaryDesignVisibility: function () {

        $j('button[id="study_primary_design_next_button"]').removeClass('hidden');

        design = $j(this).val();

        switch (design){
            case 'Interventional':

                $j('div[id="study_design_interventional"]').parent().parent().show();
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                $j('button[id="study_primary_design_next_button"]').attr('onclick','toggle(\'study_design_interventional\')');
                break;

            case 'Non-interventional':
                $j('div[id="study_design_non_interventional"]').parent().parent().show();
                $j('div[id="study_design_interventional"]').parent().parent().hide();
                $j('button[id="study_primary_design_next_button"]').attr('onclick','toggle(\'study_design_non_interventional\')');
                break;

            default:
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                $j('div[id="study_design_interventional"]').parent().parent().hide();
                $j('button[id="study_primary_design_next_button"]').addClass('hidden');

        }
    },


    intialStudyAttributesVisibility: function () {

        study_primary_design = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();
        study_status = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status]"]').val();
        study_masking = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]').val();


        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').parent().hide();
        $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().hide();


        if  (study_primary_design=="Interventional" && (study_status=="At the planning stage" || study_status.startsWith('Ongoing'))){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').parent().show();
        }

        if (study_status.startsWith('Suspended') || study_status .startsWith('Terminated')) {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').parent().show();
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').parent().show();
        }


        if  (study_masking=="Yes") {
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().show();
        }

    },

    setStudyAttributesVisibility: function () {

        study_primary_design = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();
        study_status = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status]"]').val();
        study_masking = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]').val();

        if  (study_primary_design=="Interventional" && (study_status == "At the planning stage" || study_status.startsWith('Ongoing'))) {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').parent().show();
        }else{
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').parent().hide();
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').val('');

        }

        if (study_status.startsWith('Suspended') || study_status .startsWith('Terminated')) {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').parent().show();
            $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').parent().show();
        }else{
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').parent().hide();
            $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').parent().hide();

        }

        if  (study_masking=="Yes") {
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().show();
        }else{
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().hide();
        }

    },

    setRoleNameTypeVisibility:function () {
        role_name_type = $j(this).val();
        index = $j(this).parent().parent().attr('data-index');

        switch (role_name_type){
            case 'Personal':
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().show();
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').parent().show();
                $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').val('');
                break;

            case 'Organisational':
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').val('');
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').val('');
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').val('');
                $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').val('');
                $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').val('');
                break;

            default:
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').parent().hide();
        }
    },

    setRolePersonIdentifierSchemeAsRequirerd: function () {
        value = $j(this).val()
        index = $j(this).parent().parent().attr('data-index');
        if (value){
            $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').prev().addClass('submit-required');
        }else{
            $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').prev().removeClass('submit-required');
        }
    },

    setRoleAffiliationIdentifierSchemeAsRequirerd: function () {
        value = $j(this).val()
        index = $j(this).parent().parent().attr('data-index');
        if (value){
            $j('select[name="studyhub_resource[role_affiliation_identifier_scheme]['+index+']"]').prev().addClass('submit-required');
        }else{
            $j('select[name="studyhub_resource[role_affiliation_identifier_scheme]['+index+']"]').prev().removeClass('submit-required');
        }
    },


    removeSubmitButton: function () {
        $j('#submit_button').remove();
    },

    addAddtionalRequiredIDFields: function (){
        $j('#id-ids-alert').removeClass("hidden");
        $j('#id_id_label').addClass("required");
        $j('#id_type_label').addClass("required");
        $j('#id_relation_type_label').addClass("required");

        i = 0;

        $j('input[name^="studyhub_resource[id_id]').each( function( index, element ){
            if($j(this).val() != '') {
                i++;
            }
        });

        if ( i==0 ) {
            $j('#id-ids-alert').addClass("hidden");
            $j('#id_id_label').removeClass("required");
            $j('#id_type_label').removeClass("required");
            $j('#id_relation_type_label').removeClass("required");
        }
    },

    addAddtionalRequiredFieldStudyConditionsClassificationCode: function () {

        if ( $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_conditions]"]').val() != ''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_conditions_classification]"]').prev().addClass('submit-required');
        }else {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_conditions_classification]"]').prev().removeClass('submit-required');
        }
    },

    addAddtionalRequiredFieldStudyArmGroupType: function () {

        if ( $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').val() != ''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').prev().addClass('submit-required');
        }else {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').prev().removeClass('submit-required');
        }
    },

    intialRequiredFields: function (){

        if ( $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_conditions]"]').val() != ''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_conditions_classification]"]').prev().addClass('submit-required');
        }

        if ( $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').val() != ''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').prev().addClass('submit-required');
        }

        study_outcome_title =  $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_title]"]').val()
        study_outcome_description =  $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_description]"]').val()
        if ( study_outcome_title != '' || study_outcome_description !=''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_type]"]').prev().addClass('submit-required');
        }

    },

    addAddtionalRequiredStudyOutcomeType: function () {
        study_outcome_title =  $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_title]"]').val()
        study_outcome_description =  $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_description]"]').val()
        if ( study_outcome_title != '' || study_outcome_description !=''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_type]"]').prev().addClass('submit-required');
        } else {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_outcome_type]"]').prev().removeClass('submit-required');
        }
    },

    intialRolesVisibility: function (){
        $j('select[name^="studyhub_resource[role_type]').each( function( index, element ){
            index = $j(this).parent().parent().attr('data-index');
            if (index != 'row-template') {
                intialRoleVisibility(index);
            }
        });
    }

};

function intialRoleVisibility(index) {

    $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().hide();
    $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').parent().hide();
    $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').parent().hide();


    if($j('input[name="studyhub_resource[role_affiliation_identifier]['+index+']"]').val() != ''){
        $j('select[name="studyhub_resource[role_affiliation_identifier_scheme]['+index+']"]').prev().addClass('submit-required');
    }else{
        $j('select[name="studyhub_resource[role_affiliation_identifier_scheme]['+index+']"]').prev().removeClass('submit-required');
    }

    role_name_type = $j('select[name="studyhub_resource[role_name_type]['+index+']"]').val()

    switch (role_name_type){
        case 'Personal':
            $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().show();
            $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().show();
            $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().show();
            $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').parent().show();
            $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').parent().show();

            if($j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').val() != ''){
                $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').prev().addClass('submit-required');
            }else{
                $j('select[name="studyhub_resource[role_name_identifier_scheme]['+index+']"]').prev().removeClass('submit-required');
            }

            break;
        case 'Organisational':
            $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().show();
            break;
        default:

    }
}

function toggle(block_id) {

    if($j('#'+block_id).parent().attr("aria-expanded") == 'false') {
        $j('#'+block_id).parent('.collapse').collapse();
    }

    $j("html").animate(
        {
            scrollTop: $j('#'+block_id).parent().parent().offset().top
        },
        800 //speed
    );
}


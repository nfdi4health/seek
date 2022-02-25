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

    removeKeywordsRow: function () {
        var row = $j(this).parents('.resource-keyword');
        row.remove();
    },

    removeRoleIdentifersRow: function () {
        var row = $j(this).parents('.resource-identifier');
        row.remove();
    },

    removeRoleRow: function () {
        var row = $j(this).parents('.resource-role');
        row.remove();
    },

    removeSingleRow: function () {
        var row = $j(this).parents('.single-role');
        row.remove();
    },

    enableNextButton: function () {
        if ($j(this).val() == '') {
            $j('#select_sr_type_button').prop('disabled', true);
        } else {
            $j('#select_sr_type_button').prop('disabled', false);
        }

    },

     hideResourceAttributes: function () {
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][resource_version]"]').parent().hide();
        $j('input[name="studyhub_resource[custom_metadata_attributes][data][resource_format]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_type_general]"]').val('Other');
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_type_general]"]').parent().hide();
    },

    intialResourceUseRightVisibility: function () {
        check_license = $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_label]"]').val();

        if (check_license == '') {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_label]"]').val('Not applicable');
        }

        if (check_license.startsWith('CC')) {
            $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').parent().parent().show();
            $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').parent().parent().show();
        }else {
            $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').parent().parent().hide();
            $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').parent().parent().hide();
        }
    },

    setResourceUseRightVisibility: function () {
        check_license = $j(this).val();
        if (check_license.startsWith('CC')) {
           $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').parent().parent().show();
           $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').parent().parent().show();
        }
        else{
            $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').parent().parent().hide();
            $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').parent().parent().hide();
            $j('input:radio[name^="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_authors_confirmation"]').prop('checked', false);
            $j('input:radio[name="studyhub_resource[custom_metadata_attributes][data][resource_use_rights_support_by_licencing]"]').prop('checked', false);
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

            $j('div[id="studyhub_resource_custom_metadata_attributes_data_study_data_sharing_plan_supporting_information"]').children().eq(1).empty();
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_time_frame]"]').val('');
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_access_criteria]"]').val('');
            $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_data_sharing_plan_url]"]').val('');
        }
    },

    intialStudyPrimaryDesignVisibility: function () {
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').parent().hide();
        $j('div[id="study_design_non_interventional"]').parent().parent().hide();
        $j('div[id="study_design_interventional"]').parent().parent().hide();

        design = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();
        options = setStudyTypeOptions(design);
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').html(options);

        switch (design){
            case 'Interventional':
                $j('div[id="study_design_interventional"]').parent().parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').parent().show();
                $j('button[id="study_primary_design_next_button"]').removeClass('hidden');
                $j('button[id="study_primary_design_next_button"]').attr('onclick','toggle(\'study_design_interventional\')');
                break;

            case 'Non-interventional':
                $j('div[id="study_design_non_interventional"]').parent().parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').parent().show();
                $j('button[id="study_primary_design_next_button"]').removeClass('hidden');
                $j('button[id="study_primary_design_next_button"]').attr('onclick','toggle(\'study_design_non_interventional\')');
                break;
        }
    },

    setStudyPrimaryDesignVisibility: function () {

        $j('div[id="study_design_non_interventional"]').parent().parent().hide();
        $j('div[id="study_design_interventional"]').parent().parent().hide();

        design = $j(this).val();
        options = setStudyTypeOptions(design)

        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').parent().show();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').html(options);

        switch (design){
            case 'Interventional':
                $j('div[id="study_design_interventional"]').parent().parent().show();
                break;
            case 'Non-interventional':
                $j('div[id="study_design_non_interventional"]').parent().parent().show();
                break;
            default:
                $j('button[id="study_primary_design_next_button"]').addClass('hidden');

        }
    },


    intialStudyAttributesVisibility: function () {

        study_primary_design = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();
        study_status = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status]"]').val();
        study_masking = $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]:checked').val();

        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').parent().hide();
        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').parent().hide();
        $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').parent().hide();
        $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().hide();


        if  (study_primary_design=="Interventional" && (study_status=="At the planning stage" || study_status.startsWith('Ongoing'))){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_when_intervention]"]').parent().show();
        }

        if (study_status.startsWith('Suspended') || study_status .startsWith('Terminated')) {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').parent().show();
            $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').parent().show();
        }


        if  (study_masking == "true") {
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().show();
        }

    },

    setStudyAttributesVisibility: function () {

        study_primary_design = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();
        study_status = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status]"]').val();
        study_masking = $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_masking]"]:checked').val();


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
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_stage]"]').val('');
            $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').parent().hide();
            $j('textarea[name="studyhub_resource[custom_metadata_attributes][data][study_status_halted_reason]"]').val('');
        }

        if  (study_masking =="true") {
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().show();
        }else{
            $j('div[name="studyhub_resource[custom_metadata_attributes][data][study_masking_roles]"]').parent().hide();
            $j('div[id="studyhub_resource_custom_metadata_attributes_data_study_masking_roles"]').children().eq(1).empty();
        }

    },

    setRoleNameTypeVisibility:function () {
        role_name_type = $j(this).val();
        index = $j(this).parent().parent().attr('data-index');

        switch (role_name_type){
            case 'Personal':
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_given_name]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_family_name]['+index+']"]').parent().show();
                $j('select[name="studyhub_resource[resource_json][roles][role_name_personal_title]['+index+']"]').parent().show();
                $j('#resource_identifiers-'+index).show();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_organisational]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_organisational]['+index+']"]').val('');
                break;

            case 'Organisational':
                $j('input[name="studyhub_resource[resource_json][roles][role_name_organisational]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_given_name]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_family_name]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[resource_json][roles][role_name_personal_title]['+index+']"]').parent().hide();
                $j('#resource_identifiers-'+index).hide();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_given_name]['+index+']"]').val('');
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_family_name]['+index+']"]').val('');
                $j('select[name="studyhub_resource[resource_json][roles][role_name_personal_title]['+index+']"]').val('');
                $j('input[name^="studyhub_resource[resource_json][roles][role_name_identifier]['+index+']"]').val('');
                $j('select[name^="studyhub_resource[resource_json][roles][role_name_identifier_scheme]['+index+']"]').val('');
                break;
            default:
                $j('input[name="studyhub_resource[resource_json][roles][role_name_organisational]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_given_name]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_family_name]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[resource_json][roles][role_name_personal_title]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[resource_json][roles][role_name_identifier]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[resource_json][roles][role_name_identifier_scheme]['+index+']"]').parent().hide();
        }
    },

    setRoleIdentifierSchemeAsRequirerd: function () {
        value = $j(this).val()
        scheme_name = $j(this).attr("name").replace('identifier', 'identifier_scheme')
        if (value){
            $j('select[name="'+scheme_name+'"]').parent().addClass('submit-required');
        }else{
            $j('select[name="'+scheme_name+'"]').parent().removeClass('submit-required');
        }
    },

    setRoleAffiliationIdentifierSchemeAsRequirerd: function () {
        value = $j(this).val();
        index = $j(this).parent().parent().attr('data-index');
        if (value){
            $j('select[name="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']"]').prev().addClass('submit-required');
        }else{
            $j('select[name="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']"]').prev().removeClass('submit-required');
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

        $j('input[name^="studyhub_resource[resource_json][ids][id_id]').each( function( index, element ){
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

    addAddtionalRequiredStudyConditionsField: function (){
        $j('input[name^="studyhub_resource[custom_metadata_attributes][data][study_conditions][study_conditions]').each( function( index, element ){
            if($j(this).val() == '') {
                $j(this).parent().next().children('label').removeClass('submit-required');
            }else{
                $j(this).parent().next().children('label').addClass("submit-required");
            }
        });
    },

    addAddtionalRequiredOutcomesField: function (){
        $j('input[name^="studyhub_resource[custom_metadata_attributes][data][study_outcomes][study_outcome_title]').each( function( index, element ){
            if($j(this).val() == '') {
                $j(this).parent().parent().children(':first').children('label').removeClass('submit-required');
                // $j(this).parent().prev().children('label').removeClass("submit-required");
            }else{
                $j(this).parent().parent().children(':first').children('label').addClass('submit-required');
                // $j(this).parent().prev().children('label').addClass("submit-required");
            }
        });
    },

    addAddtionalRequiredStudyArmGroupsField: function (){
        $j('input[name^="studyhub_resource[custom_metadata_attributes][data][interventional_study_design_arms][study_arm_group_label]').each( function( index, element ){
            if($j(this).val() == '') {
                $j(this).parent().next().children('label').removeClass('submit-required');
            }else{
                $j(this).parent().next().children('label').addClass("submit-required");
            }
        });
    },



    addAddtionalRequiredFieldStudyArmGroupType: function () {

        if ( $j('input[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_label]"]').val() != ''){
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').prev().addClass('submit-required');
        }else {
            $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_arm_group_type]"]').prev().removeClass('submit-required');
        }
    },

    intialRequiredFields: function (){


        //study_conditions
        $j('input[name^="studyhub_resource[custom_metadata_attributes][data][study_conditions][study_conditions]').each( function( index, element ){
            if($j(this).val() != '') {
                $j(this).parent().next().children('label').addClass('submit-required');
            }
        });

        //study_outcomes
        $j('input[name^="studyhub_resource[custom_metadata_attributes][data][study_outcomes][study_outcome_title]').each( function( index, element ){
            if($j(this).val() != '') {
                $j(this).parent().parent().children(':first').children('label').addClass('submit-required');
            }
        });

        //interventional_study_design_arms
        $j('input[name^="studyhub_resource[custom_metadata_attributes][data][interventional_study_design_arms][study_arm_group_label]').each( function( index, element ){
            if($j(this).val() != '') {
                $j(this).parent().next().children('label').addClass('submit-required');
            }
        });

    },

    intialRolesVisibility: function (){
        $j('select[name^="studyhub_resource[resource_json][roles][role_type]').each( function( index, element ){
            index = $j(this).parent().parent().attr('data-index');
            if (index != 'row-template') {
                intialRoleVisibility(index);
            }
        });
    }

};


function setStudyTypeOptions(type) {
    const interventional_options = ['Single Group', ' Parallel', 'Crossover', 'Factorial', 'Sequential', 'Other', 'Unknown']
    const non_interventional_options = ['Case-control', 'Case-only', 'Case-crossover', 'Ecologic or community studies', 'Family-based',
        'Twin study', 'Cohort', ' Birth cohort', 'Trend', 'Panel',
        'Longitudinal', 'Cross-section', 'Cross-section ad-hoc follow-up', 'Time series',
        'Quality control', 'Other', 'Unknown']

    if (type == 'Interventional') {
        study_type_options = interventional_options
    }
    else if (type == 'Non-interventional')
    {
        study_type_options = non_interventional_options
    }
    else{
        study_type_options = ""
    }

    var options =  '<option value>Please select...</option>';
    for (const value of study_type_options ){

        options += '<option value="'+value+'">'+value+'</option>';
    }
    return options
}


function setStudyType(type) {
    $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type]"]').val(type);
}

function intialRoleVisibility(index) {

    $j('input[name="studyhub_resource[resource_json][roles][role_name_organisational]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_given_name]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_family_name]['+index+']"]').parent().hide();
    $j('select[name="studyhub_resource[resource_json][roles][role_name_personal_title]['+index+']"]').parent().hide();

    $j('#resource_identifiers-'+index).hide();

    if($j('input[name="studyhub_resource[resource_json][roles][role_affiliation_identifier]['+index+']"]').val() != ''){
        $j('select[name="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']"]').prev().addClass('submit-required');
    }else{
        $j('select[name="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']"]').prev().removeClass('submit-required');
    }

    role_name_type = $j('select[name="studyhub_resource[resource_json][roles][role_name_type]['+index+']"]').val()

    switch (role_name_type){
        case 'Personal':
            $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_given_name]['+index+']"]').parent().show();
            $j('input[name="studyhub_resource[resource_json][roles][role_name_personal_family_name]['+index+']"]').parent().show();
            $j('select[name="studyhub_resource[resource_json][roles][role_name_personal_title]['+index+']"]').parent().show();
            $j('#resource_identifiers-'+index).show();


            $j('select[name^="studyhub_resource[resource_json][roles][role_name_identifier_scheme]['+index+']"]').each( function( id, element ){
                if($j('input[name="studyhub_resource[resource_json][roles][role_name_identifier]['+index+']['+id+']"]').val() != ''){
                    $j('select[name="studyhub_resource[resource_json][roles][role_name_identifier_scheme]['+index+']['+id+']"]').parent().addClass('submit-required');
                }else{
                    $j('select[name="studyhub_resource[resource_json][roles][role_name_identifier_scheme]['+index+']['+id+']"]').parent().removeClass('submit-required');
                }
            });

            break;
        case 'Organisational':
            $j('input[name="studyhub_resource[resource_json][roles][role_name_organisational]['+index+']"]').parent().show();
            break;

    }


    $j('select[name^="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']"]').each( function( id, element ){
        if($j('input[name="studyhub_resource[resource_json][roles][role_affiliation_identifier]['+index+']['+id+']"]').val() != ''){
            $j('select[name="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']['+id+']"]').parent().addClass('submit-required');
        }else{
            $j('select[name="studyhub_resource[resource_json][roles][role_affiliation_identifier_scheme]['+index+']['+id+']"]').parent().removeClass('submit-required');
        }
    });
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


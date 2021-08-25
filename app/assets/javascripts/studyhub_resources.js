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

        study_type = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_primary_design]"]').val();

        switch (study_type){
            case 'interventional':
                $j('div[id="study_design_interventional"]').parent().parent().show();
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                break;

            case 'non-interventional':
                $j('div[id="study_design_non_interventional"]').parent().parent().show();
                $j('div[id="study_design_interventional"]').parent().parent().hide();
                break;

            default:
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                $j('div[id="study_design_interventional"]').parent().parent().hide();

        }

    },

    setRoleNameTypeVisibility:function () {
        role_name_type = $j(this).val();
         // alert ($j(this).parent().parent().attr('data-index'))
        index = $j(this).parent().parent().attr('data-index');

        switch (role_name_type){
            case 'Personal':
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().show();
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().hide();
                break;

            case 'Organisational':
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().show();
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().hide();
                break;

            default:
                $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().hide();
                $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().hide();
                $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().hide();
        }
    },

    // setRoleRequirerdAttributes:function () {
    //     role_name_type = $j(this).val();
    //     index = $j(this).parent().parent().attr('data-index');
    //     switch (role_name_type){
    //         case 'Personal':
    //             $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').prev().addClass('required');
    //             break;
    //         case 'Organisational':
    //             $j('input[name="studyhub_resource[role_name_identifier]['+index+']"]').prev().removeClass('required');
    //             break;
    //     }
    // },

    setRolePersonIdentifierSchemeAsRequirerd: function () {
        value = $j(this).val()
        index = $j(this).parent().parent().attr('data-index');
        alert(index);
        if (value){
            alert("value:"+value);
            $j('select[name="studyhub_resource[role_name_identifier_schemes]['+index+']"]').prev().addClass('required');
        }
        },

    setStudyPrimaryDesignVisibility: function () {

        design = $j(this).val();

        switch (design){
            case 'interventional':

                $j('div[id="study_design_interventional"]').parent().parent().show();
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                break;

            case 'non-interventional':

                $j('div[id="study_design_non_interventional"]').parent().parent().show();
                $j('div[id="study_design_interventional"]').parent().parent().hide();
                break;

            default:
                $j('div[id="study_design_non_interventional"]').parent().parent().hide();
                $j('div[id="study_design_interventional"]').parent().parent().hide();

        }
    },

    removeSubmitButton: function () {
        $j('#submit_button').remove();
    }
};

function intialRoleVisibility(index) {
    $j('input[name="studyhub_resource[role_name_organisational]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[role_name_personal_given_name]['+index+']"]').parent().hide();
    $j('input[name="studyhub_resource[role_name_personal_family_name]['+index+']"]').parent().hide();
    $j('select[name="studyhub_resource[role_name_personal_title]['+index+']"]').parent().hide();
}
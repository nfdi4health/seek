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

    intialStudyPrimaryDesignVisibility: function () {

        $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
         $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();

    },

    setStudyPrimaryDesignVisibility: function () {

        design = $j(this).val();
        switch (design){
            case 'interventional':
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().show();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();
                break;
            case 'non-interventional':
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().show();
                break;
            default:
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
                $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();
        }
    }

};

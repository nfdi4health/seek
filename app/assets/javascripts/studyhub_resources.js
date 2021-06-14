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

    intialStudyPrimaryDesignVisibility: function () {

        study_type_interventional = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_interventional]"]').parent().hide();
        study_type_interventional = $j('select[name="studyhub_resource[custom_metadata_attributes][data][study_type_non_interventional]"]').parent().hide();

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
    },

    setSpecificRoleTypeVisibility: function () {

        role_type = $j(this).val();
        switch (role_type){
            case 'Sponsor':
                $j(this).parents('.resource-role').find('.role_specific_type_sponsor').show();
                $j(this).parents('.resource-role').find('.role_specific_type_funder').hide();
                break;
            case 'Funder':
                $j(this).parents('.resource-role').find('.role_specific_type_funder').show();
                $j(this).parents('.resource-role').find('.role_specific_type_sponsor').hide();
                break;
            default:
                $j(this).parents('.resource-role').find('.role_specific_type_funder').hide();
                $j(this).parents('.resource-role').find('.role_specific_type_sponsor').hide();
        }
    }

};

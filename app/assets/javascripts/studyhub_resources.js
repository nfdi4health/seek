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

    setSpecificRoleTypeVisible: function () {

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

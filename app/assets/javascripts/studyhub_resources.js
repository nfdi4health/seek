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
    }

};

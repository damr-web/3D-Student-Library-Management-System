package com.library.dao;

import com.library.model.Admin;

public interface AdminDAO {
    Admin loginAdmin(String username, String password);
    Admin getAdminById(int id);
}


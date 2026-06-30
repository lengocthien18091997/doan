document.addEventListener("DOMContentLoaded", function () {
    function sanitizeKey(str) {
        if (!str) return "";
        return str.toString().trim().replace(/[\[\]\/\\%]/g, "").replace(/\s+/g, "_");
    }

    function setupDynamic(containerSelector, addBtnId, field, placeholder, optionsHtml) {
        const container = document.querySelector(containerSelector);
        const addBtn = document.getElementById(addBtnId);
        if (!container || !addBtn) return;

        // Xóa dòng
        container.addEventListener("click", function (e) {
            if (e.target.classList.contains("remove-row")) {
                e.target.closest(".field-row").remove();
            }
        });

        // Khi user đổi tên -> đổi name input/select tương ứng
        function wireInputRename(inputEl, selectEl) {
            inputEl.addEventListener("input", function () {
                const key = sanitizeKey(inputEl.value);
                if (!key) return;
                const newName = `user[teacher_profile_attributes][${field}][${key}]`;
                inputEl.name = newName;
                selectEl.name = newName;
            });
        }

        // Add sự kiện rename cho các dòng có sẵn
        container.querySelectorAll(".field-row").forEach(row => {
            const inputEl = row.querySelector('input[type="text"]');
            const selectEl = row.querySelector("select");
            if (inputEl && selectEl) wireInputRename(inputEl, selectEl);
        });

        // Thêm dòng mới
        addBtn.addEventListener("click", function () {
            const row = document.createElement("div");
            row.className = "field-row mb-2 d-flex align-items-center";
            row.innerHTML = `
        <input type="text"
               class="form-control me-2 w-50"
               placeholder="${placeholder}">
        <select class="form-select w-25">
          ${optionsHtml}
        </select>
        <button type="button" class="btn btn-danger btn-sm ms-2 remove-row">–</button>
      `;
            container.appendChild(row);

            const inputEl = row.querySelector('input[type="text"]');
            const selectEl = row.querySelector("select");
            if (inputEl && selectEl) wireInputRename(inputEl, selectEl);
        });

        // Trước khi submit: bỏ row chưa nhập tên
        const form = container.closest("form");
        if (form) {
            form.addEventListener("submit", function () {
                container.querySelectorAll(".field-row").forEach(row => {
                    const inputEl = row.querySelector('input[type="text"]');
                    if (!inputEl.value.trim()) row.remove();
                });
            });
        }
    }

    const subjectsOptions = `
    <option value="Cấp 1">Cấp 1</option>
    <option value="Cấp 2">Cấp 2</option>
    <option value="Cấp 3">Cấp 3</option>
  `;
    const availOptions = `
    <option value="Buổi sáng">Buổi sáng</option>
    <option value="Buổi chiều">Buổi chiều</option>
    <option value="Buổi tối">Buổi tối</option>
  `;

    setupDynamic('[data-field-name="subjects"]', "add-subject", "subjects", "Tên môn học (VD: Toán)", subjectsOptions);
    setupDynamic('[data-field-name="availability"]', "add-availability", "availability", "Ngày trong tuần (VD: Thứ 2)", availOptions);
});

document.addEventListener("DOMContentLoaded", function() {
    const btn = document.getElementById("show-update-profile");
    const container = document.getElementById("update-profile-container");

    if (btn && container) {
        btn.addEventListener("click", function() {
            if (container.style.display === "none") {
                container.style.display = "block";
                btn.textContent = "Ẩn form cập nhật";
            } else {
                container.style.display = "none";
                btn.textContent = "Cập nhật hồ sơ";
            }
        });
    }
});

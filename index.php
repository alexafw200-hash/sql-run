<?php
// إعدادات الاتصال
$host = "127.0.0.1";
$user = "root";
$pass = "";
$dbname = "my_website";
$conn = new mysqli($host, $user, $pass, $dbname);
// التأكد من نجاح الاتصال
if ($conn->connect_error) {
    die("<div style='color:red'>فشل الاتصال: " . $conn->connect_error . "</div>");
}
$message = "";
$result_data = null;
// تنفيذ الاستعلام عند الضغط على زر "تنفيذ"
if (isset($_POST['execute'])) {
    $sql = $_POST['sql_command'];
    
    try {
        $query_result = $conn->query($sql);
        
        if ($query_result === TRUE) {
            $message = "<div style='color:green'>تم تنفيذ الاستعلام بنجاح.</div>";
        } elseif ($query_result instanceof mysqli_result) {
            $result_data = $query_result;
        } else {
            $message = "<div style='color:red'>خطأ: " . $conn->error . "</div>";
        }
    } catch (Exception $e) {
        $message = "<div style='color:red'>خطأ في الاستعلام: " . $e->getMessage() . "</div>";
    }
}
?>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>محاكي أوراكل SQL</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Courier New', monospace;
            background: #2c3e50;
            color: #ecf0f1;
            padding: 10px;
            min-height: 100vh;
        }

        .terminal {
            background: #1c1c1c;
            padding: 15px;
            border-radius: 10px;
            border: 2px solid #34495e;
            max-width: 1200px;
            margin: 0 auto;
        }

        h2 {
            margin-bottom: 20px;
            font-size: clamp(1.2rem, 5vw, 2rem);
            text-align: center;
        }

        h3 {
            margin-top: 20px;
            margin-bottom: 15px;
            font-size: clamp(1rem, 4vw, 1.5rem);
        }

        p {
            margin-bottom: 10px;
            font-size: clamp(0.9rem, 3vw, 1rem);
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        textarea {
            width: 100%;
            height: auto;
            min-height: 100px;
            background: #000;
            color: #00ff00;
            border: 1px solid #444;
            padding: 10px;
            font-size: clamp(0.85rem, 2.5vw, 1rem);
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            resize: vertical;
        }

        button {
            background: #27ae60;
            color: white;
            border: none;
            padding: 12px 20px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
            border-radius: 5px;
            font-size: clamp(0.9rem, 3vw, 1rem);
            transition: background-color 0.3s ease;
            width: 100%;
        }

        button:hover {
            background: #2ecc71;
        }

        button:active {
            transform: scale(0.98);
        }

        .log {
            margin-top: 15px;
            font-weight: bold;
            font-size: clamp(0.85rem, 2.5vw, 1rem);
            padding: 10px;
            border-radius: 5px;
        }

        /* جدول متجاوب */
        .table-wrapper {
            overflow-x: auto;
            margin-top: 20px;
            border-radius: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            color: black;
            min-width: 300px;
        }

        th, td {
            border: 1px solid #bdc3c7;
            padding: 10px;
            text-align: right;
            font-size: clamp(0.8rem, 2vw, 0.95rem);
            word-wrap: break-word;
        }

        th {
            background: #34495e;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #ecf0f1;
        }

        .results-info {
            margin-top: 15px;
            padding: 10px;
            background: #34495e;
            border-radius: 5px;
            font-size: clamp(0.85rem, 2.5vw, 1rem);
        }

        /* تصميم متجاوب للشاشات الصغيرة */
        @media (max-width: 768px) {
            body {
                padding: 5px;
            }

            .terminal {
                padding: 10px;
                border-radius: 8px;
            }

            h2 {
                margin-bottom: 15px;
            }

            button {
                padding: 10px 15px;
            }

            th, td {
                padding: 8px 5px;
            }

            .table-wrapper {
                margin-top: 15px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 0;
            }

            .terminal {
                padding: 8px;
                border-radius: 5px;
                border: 1px solid #34495e;
            }

            h2 {
                font-size: 1.1rem;
                margin-bottom: 10px;
            }

            h3 {
                font-size: 0.95rem;
                margin-top: 15px;
            }

            p {
                margin-bottom: 8px;
            }

            form {
                gap: 8px;
            }

            textarea {
                min-height: 80px;
                padding: 8px;
            }

            button {
                padding: 10px;
                margin-top: 8px;
            }

            th, td {
                padding: 6px 4px;
                font-size: 0.75rem;
            }

            .log {
                margin-top: 10px;
                padding: 8px;
                font-size: 0.85rem;
            }

            .results-info {
                margin-top: 10px;
                padding: 8px;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
<div class="terminal">
    <h2><span style="color: #e67e22;">SQL</span> Command Terminal</h2>
    <form method="POST">
        <p>اكتب استعلام SQL هنا (مثل SELECT * FROM users):</p>
        <textarea name="sql_command" placeholder="SELECT * FROM ..."><?php echo isset($_POST['sql_command']) ? htmlspecialchars($_POST['sql_command']) : ''; ?></textarea>
        <button type="submit" name="execute">Execute (تنفيذ)</button>
    </form>
    <div class="log"><?php echo $message; ?></div>
    <?php if ($result_data): ?>
        <h3>نتائج الاستعلام:</h3>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <?php 
                        // جلب أسماء الأعمدة تلقائياً
                        $fields = $result_data->fetch_fields();
                        foreach ($fields as $field) {
                            echo "<th>" . htmlspecialchars($field->name) . "</th>";
                        }
                        ?>
                    </tr>
                </thead>
                <tbody>
                    <?php while($row = $result_data->fetch_assoc()): ?>
                    <tr>
                        <?php foreach($row as $cell): ?>
                            <td><?php echo htmlspecialchars($cell ?? ''); ?></td>
                        <?php endforeach; ?>
                    </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
        <div class="results-info">إجمالي النتائج: <?php echo $result_data->num_rows; ?></div>
    <?php endif; ?>
</div>
</body>
</html>

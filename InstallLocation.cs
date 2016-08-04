using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ExercismWinSetup
{
    public partial class InstallLocation : Form
    {
        public InstallLocation()
        {
            InitializeComponent();
        }

        private void browseButton_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                installPath.Text = folderBrowserDialog.SelectedPath;
            }
            
        }
    }
}

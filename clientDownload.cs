using System;
using System.IO;
using System.Net;
using Newtonsoft.Json;
using System.Windows.Forms;
using Newtonsoft.Json.Linq;

namespace ExercismWinSetup
{
    public partial class ClientDownload : Form
    {
        private static string installationPath;

        public ClientDownload(string installFolder)
        {
            installationPath = installFolder;
            InitializeComponent();
            this.Shown += ClientDownload_Shown;
        }

        private void ClientDownload_Shown(object sender, EventArgs e)
        {
            bool isGitHubUp = queryGithub();
            if (isGitHubUp)
            {
                HttpWebRequest githubApiRequest = (HttpWebRequest)WebRequest.Create(@"https://api.github.com/repos/exercism/cli/releases/latest");

                githubApiRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)";

                HttpWebResponse githubApiResponse = (HttpWebResponse)githubApiRequest.GetResponse();
                string response = new StreamReader(githubApiResponse.GetResponseStream()).ReadToEnd();

                JObject exercismRelease = JObject.Parse(response);
                JToken jToken = exercismRelease.SelectToken(@"$.assets[?(@.name == 'exercism-windows-32bit.zip')].browser_download_url");
                MessageBox.Show(jToken.ToString());
            }
        }

        private bool queryGithub()
        {
            try
            {
                using (var client = new WebClient())
                {
                    client.Headers.Add("user-agent", @"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)");
                    using (var stream = client.OpenRead(@"https://api.github.com"))
                    {
                        return true;
                    }
                }
            }
            catch (Exception)
            {
                return false;
            }
            
        }

    }
}

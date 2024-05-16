output "jenkins_url" {
  description = "URL of the Jenkins instance"
  value       = helm_release.jenkins.name
}
